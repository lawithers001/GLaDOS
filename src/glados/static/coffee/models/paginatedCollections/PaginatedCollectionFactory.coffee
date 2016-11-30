glados.useNameSpace 'glados.models.paginatedCollections'
  # --------------------------------------------------------------------------------------------------------------------
  # Factory for Elastic Search Generic Paginated Results List Collection
  # Creates a paginated collection based on:
  # - MODEL: which backbone model will parse the json data that comes from elastic search
  # - PATH: the index path in the elastic search server
  # - COLUMNS: a columns description  used for ordering and the views
  # --------------------------------------------------------------------------------------------------------------------
  PaginatedCollectionFactory:

    # creates a new instance of a Paginated Collection from Elastic Search
    getNewESResultsListFor : (esIndexSettings) ->
      indexESPagQueryCollection = glados.models.paginatedCollections.ESPaginatedQueryCollection.extend
        model: esIndexSettings.MODEL

        initialize: ->

          @meta =
            index: esIndexSettings.PATH
            page_size: Settings.CARD_PAGE_SIZES[0]
            available_page_sizes: Settings.CARD_PAGE_SIZES
            current_page: 1
            to_show: []
            columns: esIndexSettings.COLUMNS
      return new indexESPagQueryCollection

    # creates a new instance of a Paginated Collection from Web Services
    getNewWSCollectionFor: (collectionSettings) ->

      wsPagCollection = glados.models.paginatedCollections.WSPaginatedCollection.extend
        model: collectionSettings.MODEL
        initialize: ->

          @meta =
            base_url: collectionSettings.BASE_URL
            page_size: collectionSettings.DEFAULT_PAGE_SIZE
            available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            columns: collectionSettings.COLUMNS

          @initialiseUrl()

      return new wsPagCollection

    # creates a new instance of a Client Side Paginated Collection from Web Services, This means that
    # the collection gets all the data is in one call and the full list is in the client all the time.
    getNewClientSideWSCollectionFor: (collectionSettings) ->

        collection = glados.models.paginatedCollections.ClientSideWSPaginatedCollection.extend
          model: collectionSettings.MODEL

          initialize: ->

            @meta =
              base_url: collectionSettings.BASE_URL
              page_size: collectionSettings.DEFAULT_PAGE_SIZE
              available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
              current_page: 1
              to_show: []
              columns: collectionSettings.COLUMNS

            @on 'reset', @resetMeta, @

        return new collection
      

    # ------------------------------------------------------------------------------------------------------------------
    # Specific instantiation of paginated collections
    # ------------------------------------------------------------------------------------------------------------------

    getNewCompoundResultsList: () ->
      return @getNewESResultsListFor(glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND)

    getNewDocumentResultsList: () ->
      return @getNewESResultsListFor(glados.models.paginatedCollections.Settings.ES_INDEXES.DOCUMENT)

    getNewDrugList: ->
      list =  @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.DRUG_LIST)
      list.parse = (data) ->

          data.page_meta.records_in_page = data.molecules.length
          @resetMeta(data.page_meta)

          return data.molecules

      return list

    getNewDocumentsFromTermsList: ->

      list =  @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.DOCS_BY_TERM_LIST)

      list.initURL = (term) ->

        @baseUrl = Settings.WS_BASE_URL + 'document_term.json?term_text=' + term + '&order_by=-score'
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()

      list.fetch = ->

        @reset()
        url = @getPaginatedURL()
        documents = []
        totalDocs = 0
        receivedDocs = 0
        # 1 first get list of documents
        getDocuments = $.getJSON(url)

        thisCollection = @
        # 3. check that everything is ready
        checkAllInfoReady = ->
          if receivedDocs == totalDocs
            console.log 'ALL READY!'
            console.log thisCollection
            thisCollection.trigger('do-repaint')

        getDocuments.done( (data) ->

          data.page_meta.records_in_page = data.document_terms.length
          thisCollection.resetMeta(data.page_meta)

          documents = data.document_terms
          totalDocs = documents.length

          # 2. get details per document
          for docInfo in documents

            doc = new Document(docInfo)
            thisCollection.add doc
            doc.fetch
              success: ->
                receivedDocs += 1
                checkAllInfoReady()

        )

        getDocuments.fail ->

          console.log 'ERROR!'

      return list

    getNewApprovedDrugsClinicalCandidatesList: ->

      list = @getNewClientSideWSCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST)

      list.initURL = (chembl_id) ->
        @url = Settings.WS_BASE_URL + 'mechanism.json?target_chembl_id=' + chembl_id

      list.fetch = ->

        this_collection = @
        drug_mechanisms = {}

        # 1 first get list of drug mechanisms
        getDrugMechanisms = $.getJSON(@url, (data) ->
          drug_mechanisms = data.mechanisms
        )

        getDrugMechanisms.fail( ()->

          console.log('error')
          this_collection.trigger('error')

        )

        base_url2 = Settings.WS_BASE_URL + 'molecule.json?molecule_chembl_id__in='
        # after I have the drug mechanisms now I get the molecules
        getDrugMechanisms.done(() ->


          molecules_list = (dm.molecule_chembl_id for dm in drug_mechanisms).join(',')
          # order is very important to iterate in the same order as the first call
          getMoleculesInfoUrl = base_url2 + molecules_list + '&order_by=molecule_chembl_id&limit=1000'

          getMoleculesInfo = $.getJSON(getMoleculesInfoUrl, (data) ->

            molecules = data.molecules
            # Now I fill the missing information, both arrays are ordered by molecule_chembl_id
            i = 0
            for mol in molecules

              drug_mechanisms[i].max_phase = mol.max_phase
              drug_mechanisms[i].pref_name = mol.pref_name

              i++

            # here everything is ready
            this_collection.reset(drug_mechanisms)


          )

          getMoleculesInfo.fail( ()->

            console.log('failed2')

          )


        )

      return list