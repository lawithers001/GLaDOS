class SearchResultsApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->
    @eSQueryExplainView = glados.views.SearchResults.ESQueryExplainView.getInstance()

    $searchResultsContainer = $('.BCK-SearchResultsContainer')
    new glados.views.SearchResults.SearchResultsView
      el: $searchResultsContainer
      model: SearchModel.getInstance()

  # --------------------------------------------------------------------------------------------------------------------
  # Views
  # --------------------------------------------------------------------------------------------------------------------

  @initSubstructureSearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getSubstructureSearchQueryString()
    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSubstructureSearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM

    queryParams =
      search_term: GlobalVariables.SEARCH_TERM

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      query_params: queryParams

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')
    @initBrowserFromWSResults(resultsList, $browserContainer, $progressElement, $noResultsDiv, undefined,
      glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SUBSTRUCTURE_HIGHLIGHTING,
      GlobalVariables.SEARCH_TERM)

  @initSimilaritySearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getSimilaritySearchQueryString()
    GlobalVariables.SIMILARITY_PERCENTAGE = URLProcessor.getSimilaritySearchPercentage()
    queryParams =
      search_term: GlobalVariables.SEARCH_TERM
      similarity_percentage: GlobalVariables.SIMILARITY_PERCENTAGE

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      query_params: queryParams

    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM, GlobalVariables.SIMILARITY_PERCENTAGE

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')
    @initBrowserFromWSResults(resultsList, $browserContainer, $progressElement, $noResultsDiv,
      [Compound.COLUMNS.SIMILARITY_ELASTIC],
      glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_SIMILARITY_MAPS,
      GlobalVariables.SEARCH_TERM)

  @initFlexmatchSearchResults = () ->
    GlobalVariables.SEARCH_TERM = URLProcessor.getUrlPartInReversePosition(0)

    queryParams =
      search_term: GlobalVariables.SEARCH_TERM

    $queryContainer = $('.BCK-query-Container')
    new glados.views.SearchResults.StructureQueryView
      el: $queryContainer
      query_params: queryParams

    resultsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewFlexmatchSearchResultsList()
    resultsList.initURL GlobalVariables.SEARCH_TERM

    $progressElement = $('#BCK-loading-messages-container')
    $browserContainer = $('.BCK-BrowserContainer')
    $browserContainer.hide()
    $noResultsDiv = $('.no-results-found')
    @initBrowserFromWSResults(resultsList, $browserContainer, $progressElement, $noResultsDiv)

  @initBrowserFromWSResults = (resultsList, $browserContainer, $progressElement, $noResultsDiv, contextualColumns,
    customSettings, searchTerm) ->
    esCompoundsList = undefined
    browserView = undefined
    doneCallback = (finalCall=false)->

      if resultsList.allResults.length == 0
        $progressElement.hide()
        $browserContainer.hide()
        $noResultsDiv.show()
        return
      $browserContainer.show()
      browserCover = $browserContainer.find('.div-cover')
      if finalCall
        browserCover.hide()
      else
        browserCover.show()
      if not esCompoundsList?
        esCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList(undefined,
          resultsList.allResults, contextualColumns, customSettings, searchTerm)
        if resultsList.getMeta('total_all_results') > query_first_n
          esCompoundsList.setMeta('out_of_n', resultsList.getMeta('total_all_results'))

        browserView = new glados.views.Browsers.BrowserMenuView
          collection: esCompoundsList
          el: $browserContainer
      else
        esCompoundsList.setMeta('generator_items_list', resultsList.allResults)
        console.warn('Setting meta!', finalCall)
      esCompoundsList.fetch()

    debouncedDoneCallback = _.debounce(doneCallback, 500, true)

    query_first_n = 10000
    deferreds = resultsList.getAllResults($progressElement, askingForOnlySelected=false, onlyFirstN=query_first_n,
    customBaseProgressText='Searching . . . ', customProgressCallback=debouncedDoneCallback)

    # for now, we need to jump from web services to elastic
    $.when.apply($, deferreds).done(doneCallback.bind(@, true)).fail((msg) ->

      customExplanation = 'Error while performing the search.'
      $browserContainer.hide()
      if $progressElement?
        # it can be a jqxr
        if msg.status?
          $progressElement.html glados.Utils.ErrorMessages.getCollectionErrorContent(msg, customExplanation)
        else
          $progressElement.html Handlebars.compile($('#Handlebars-Common-CollectionErrorMsg').html())
            msg: msg
            custom_explanation: customExplanation
    )

