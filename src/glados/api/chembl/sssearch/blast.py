from urllib.parse import urlencode
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from . import search_manager
import json
from glados.models import SSSearchJob
import requests
import os
from django_rq import job
import xml.etree.ElementTree as ET
import re
import traceback
from glados.usage_statistics import glados_server_statistics
from dateutil import parser
import socket
from django.core.cache import cache


BLAST_API_BASE_URL = 'https://www.ebi.ac.uk/Tools/services/rest/ncbiblast'


def get_sequence_search_status(search_id):

    status_url = '{}/status/{}'.format(BLAST_API_BASE_URL, search_id)
    r = requests.get(status_url)
    status_response = r.text

    if status_response == 'NOT_FOUND':
        response = {
            'status': SSSearchJob.ERROR,
            'msg': 'Search submission not found, it may have expired. Please run the search again.'
        }
    elif status_response == 'FAILURE':
        response = {
            'status': SSSearchJob.ERROR,
            'msg': 'There was an error in the EBI BLAST Search.'
        }
    elif status_response == 'RUNNING':
        response = {
            'status': SSSearchJob.SEARCH_QUEUED
        }
    elif status_response == 'FINISHED':
        response = check_blast_job_results(search_id)
    else:
        response = {
            'status': SSSearchJob.SEARCH_QUEUED
        }

    response['ebi_status_response'] = status_response
    return response


# ----------------------------------------------------------------------------------------------------------------------
# Getting params
# ----------------------------------------------------------------------------------------------------------------------
PARAMS_SEARCH_LINKS = {
    'matrix': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-matrix',
    'gapopen': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
               '(ProteinDatabases)-gapopen',
    'gapext': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-gapext',
    'exp': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
           '(ProteinDatabases)-exp',
    'filter': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-filter',
    'dropoff': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
               '(ProteinDatabases)-dropoff',
    'scores': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
              '(ProteinDatabases)-scores',
    'alignments': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST'
                  '+(ProteinDatabases)-alignments',
    'seqrange': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
                '(ProteinDatabases)-seqrange',
    'gapalign': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
                '(ProteinDatabases)-gapalign',
    'align': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
             '(ProteinDatabases)-align',
    'compstats': 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+'
                 '(ProteinDatabases)-compstats'
}


def get_blast_params():

    cache_key = 'chembl-blast-params'
    cached_response = cache.get(cache_key)
    if cached_response is not None:
        return cached_response

    params_url = '{}/parameters'.format(BLAST_API_BASE_URL)

    r = requests.get(params_url)
    xml_response = r.text
    results_root = ET.fromstring(xml_response)

    all_param_names = [param.text for param in results_root]
    adjustable_params = [p for p in all_param_names if
                         p not in ['program', 'task', 'match_scores', 'stype', 'database', 'transltable']]
    final_params_list = []
    for param_id in adjustable_params:
        param_details_url = '{base_url}/parameterdetails/{param_id}'.format(base_url=BLAST_API_BASE_URL,
                                                                            param_id=param_id)
        rp = requests.get(param_details_url)
        rp_xml_response = rp.text
        params_root = ET.fromstring(rp_xml_response)

        param_name = params_root.find('name').text
        param_description = params_root.find('description').text
        param_type = params_root.find('type').text
        param_values = []
        allow_free_input = param_id in ['seqrange', 'sequence']

        values_elem = params_root.find('values')
        if values_elem is not None:
            for value_desc in values_elem:
                label = value_desc.find('label').text
                value = value_desc.find('value').text
                is_default_text = value_desc.find('defaultValue').text
                is_default = True if is_default_text == 'true' else False

                value_dict = {
                    'label': label,
                    'value': value,
                    'is_default': is_default,
                }
                param_values.append(value_dict)

        param_dict = {
            'param_id': param_id,
            'param_name': param_name,
            'param_description': param_description,
            'param_type': param_type,
            'param_values': param_values,
            'allow_free_input': allow_free_input,
            'param_help_link': PARAMS_SEARCH_LINKS.get(param_id)
        }

        if allow_free_input:
            for value_dict in param_values:
                if value_dict['is_default']:
                    default_value = value_dict['value']
                    param_dict['default_value'] = default_value
                    break

        final_params_list.append(param_dict)

    response = {
        'params': final_params_list
    }

    cache.set(cache_key, response, 86400)
    return response


# ----------------------------------------------------------------------------------------------------------------------
# Running search processing
# ----------------------------------------------------------------------------------------------------------------------
def queue_blast_job(raw_search_params):

    print('raw_search_params: ', raw_search_params)
    run_url = '{}/run/'.format(BLAST_API_BASE_URL)
    search_params = json.loads(raw_search_params)

    # add fixed chembl parameters
    search_params['stype'] = 'protein'
    search_params['program'] = 'blastp'
    search_params['database'] = 'chembl'
    search_params['email'] = 'chembl@ebi.ac.uk'

    print('search_params: ')
    print(json.dumps(search_params, indent=2))

    request_data = urlencode(search_params)

    try:

        req = Request(run_url)
        req_handle = urlopen(req, request_data.encode(encoding=u'utf_8', errors=u'strict'))
        job_id = req_handle.read().decode(encoding=u'utf_8', errors=u'strict')
        req_handle.close()
        return job_id

    except HTTPError as ex:

        msg = 'Error while submitting BLAST job:\n{}'.format(repr(ex))
        raise search_manager.SSSearchError(msg)


def check_blast_job_results(search_id):
    # only at this stage I create a model in the database, because now the task is entirely mine, to load the
    # results into a context object
    context_file_path_must_be = search_manager.get_results_file_path(search_id)

    try:

        sssearch_job = SSSearchJob.objects.get(search_id=search_id)
        if sssearch_job.status == SSSearchJob.ERROR:
            response = {
                'status': SSSearchJob.ERROR,
                'msg': sssearch_job.error_message
            }
        elif sssearch_job.status == SSSearchJob.FINISHED:
            response = {
                'status': SSSearchJob.FINISHED,
            }
            context, total_results = search_manager.get_search_results_context(sssearch_job)
            response['ids'] = [k['target_chembl_id'] for k in context]
            response['total_results'] = total_results
            response['size_limit'] = search_manager.WEB_RESULTS_SIZE_LIMIT
        else:
            os.path.getsize(context_file_path_must_be)
            response = {
                'status': SSSearchJob.LOADING_RESULTS
            }

        return response

    except (FileNotFoundError, SSSearchJob.DoesNotExist) as ex:

        sssearch_job = SSSearchJob(
            search_id=search_id,
            search_type=SSSearchJob.BLAST,
            status=SSSearchJob.LOADING_RESULTS,
            log=search_manager.format_log_message('Queuing Download of Results')
        )
        sssearch_job.save()
        download_results.delay(search_id)

        response = {
            'status': SSSearchJob.LOADING_RESULTS
        }
        return response

@job
def download_results(search_id):

    print('processing search: ', search_id)
    sssearch_job = SSSearchJob.objects.get(search_id=search_id)
    sssearch_job.worker = socket.gethostname()
    sssearch_job.save()

    try:
        search_manager.append_to_job_log(sssearch_job, 'Starting to download results')

        xml_url = '{}/result/{}/xml'.format(BLAST_API_BASE_URL, search_id)
        search_manager.append_to_job_log(sssearch_job, 'Results url: {}'.format(xml_url))
        r = requests.get(xml_url)
        xml_response = r.text
        results_root = ET.fromstring(xml_response)

        ebi_schema_url = '{http://www.ebi.ac.uk/schema}'
        results_path = '{schema_url}SequenceSimilaritySearchResult/{schema_url}hits'.format(schema_url=ebi_schema_url)
        blast_results = results_root.find(results_path)

        results = []
        id_regex = re.compile('CHEMBL\d+')
        best_alignment_path = '{schema_url}alignments/{schema_url}alignment'.format(schema_url=ebi_schema_url)
        score_path = '{schema_url}score'.format(schema_url=ebi_schema_url)
        score_bits_path = '{schema_url}bits'.format(schema_url=ebi_schema_url)
        identities_path = '{schema_url}identity'.format(schema_url=ebi_schema_url)
        positives_path = '{schema_url}positives'.format(schema_url=ebi_schema_url)
        expectation_path = '{schema_url}expectation'.format(schema_url=ebi_schema_url)

        for result_child in blast_results:
            id = id_regex.match(result_child.get('id')).group()
            length = result_child.get('length')
            best_alignment = result_child.find(best_alignment_path)
            best_score = float(best_alignment.find(score_path).text)
            best_score_bits = float(best_alignment.find(score_bits_path).text)
            best_identities = float(best_alignment.find(identities_path).text)
            best_positives = float(best_alignment.find(positives_path).text)
            best_expectation = float(best_alignment.find(expectation_path).text)

            new_result = {
                'target_chembl_id': id,
                'length': length,
                'best_score': best_score,
                'best_score_bits': best_score_bits,
                'best_identities': best_identities,
                'best_positives': best_positives,
                'best_expectation': best_expectation
            }
            results.append(new_result)

        search_manager.save_results_file(results, sssearch_job)
        search_manager.append_to_job_log(sssearch_job, 'Results Ready')
        search_manager.save_search_job_state(sssearch_job, SSSearchJob.FINISHED)

        time_path = '{schema_url}Header/{schema_url}timeInfo'.format(schema_url=ebi_schema_url)
        start_time = parser.parse(results_root.find(time_path).get('start'))
        end_time = parser.parse(results_root.find(time_path).get('end'))
        time_taken = (end_time - start_time).total_seconds()
        print('time_taken: ', time_taken)
        glados_server_statistics.record_search(sssearch_job.search_type, time_taken)

    except Exception as ex:

        search_manager.save_search_job_state(sssearch_job, SSSearchJob.ERROR, repr(ex))
        tb = traceback.format_exc()
        search_manager.append_to_job_log(sssearch_job, "Error:\n{}".format(tb))
        print(tb)






