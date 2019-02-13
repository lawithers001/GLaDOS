# this handles the management of the special searches, structure (similarity, substructure, connectivity) and
# sequence (blast)
from glados.models import SSSearchJob
import json
import hashlib
import base64
from . import glados_server_statistics


class SSSearchError(Exception):
    """Base class for exceptions in this file."""
    pass


def get_search_id(search_type, raw_search_params):

    stable_raw_search_params = json.dumps(json.loads(raw_search_params), sort_keys=True)
    search_params_digest = hashlib.sha256(stable_raw_search_params.encode('utf-8')).digest()
    base64_search_params_digest = base64.b64encode(search_params_digest).decode('utf-8').replace('/', '_').replace('+', '-')

    job_id = '{}-{}'.format(search_type, base64_search_params_digest)
    return job_id


def do_search(search_type, raw_search_params):

    search_types = [s[0] for s in SSSearchJob.SEARCH_TYPES]
    if search_type not in search_types:

        raise SSSearchError(
            "search_type: {} is unknown. Possible types are: {}".format(search_type, ', '.join(search_types))
        )

    glados_server_statistics.record_search(search_type)
    job_id = get_search_id(search_type, raw_search_params)

    response = {
        'search_id': job_id
    }
    return response