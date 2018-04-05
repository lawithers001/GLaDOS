glados.useNameSpace 'glados.models.paginatedCollections',

  PaginatedCollectionBase: Backbone.Collection.extend

    initialize: ->

      @setInitialFetchingState()
      if @islinkToAllActivitiesEnabled()
        @on glados.Events.Collections.SELECTION_UPDATED, @resetLinkToAllActivitiesCache, @

    islinkToAllActivitiesEnabled: -> @getMeta('enable_activities_link_for_selected_entities') == true

    getTotalRecords: ->
      totalRecords = @getMeta('total_records')
      totalRecords ?= 0
      return totalRecords
    # ------------------------------------------------------------------------------------------------------------------
    # Downloads
    # ------------------------------------------------------------------------------------------------------------------
    downloadIsValidAndReady: ->

      if not @allResults?
        return false

      if not @DOWNLOADED_ITEMS_ARE_VALID
        return false

      for result in @allResults
        if not result?
          return false

      return true

    # ------------------------------------------------------------------------------------------------------------------
    # Link to all activities
    # ------------------------------------------------------------------------------------------------------------------
    ALL_ACTIVITIES_LINK_CACHE_PROP_NAME: 'all_activities_link_cache'

    thereAreTooManyItemsForActivitiesLink: ->

      numSelectedItems = @getNumberOfSelectedItems()
      numItemsForLink = if numSelectedItems == 0 then @getTotalRecords() else numSelectedItems
      if numItemsForLink >= glados.Settings.VIEW_SELECTION_THRESHOLDS.Heatmap[1]
        return true
      return false

    resetLinkToAllActivitiesCache: -> @setMeta(@ALL_ACTIVITIES_LINK_CACHE_PROP_NAME, undefined)
    # because of the paginated nature of the collections, it could happen that in order to get
    # all the selected ids, it has to download all the results, this is why it returns a promise.
    getLinkToAllActivitiesPromise: ->

      cache = @getMeta(@ALL_ACTIVITIES_LINK_CACHE_PROP_NAME)
      if cache?
        return jQuery.Deferred().resolve(cache)

      linkPromise = jQuery.Deferred()

      # if all items are un selected the link must be done with all of them.
      iDsPromise = @getItemsIDsPromise(onlySelected=(not @allItemsAreUnselected()))

      thisCollection = @
      iDsPromise.then (selectedIDs) ->

        link = thisCollection.getLinkToAllActivities(selectedIDs)
        thisCollection.setMeta(thisCollection.ALL_ACTIVITIES_LINK_CACHE_PROP_NAME, link)
        linkPromise.resolve(link)

      return linkPromise

    getLinkToAllActivities: (itemsList) ->
      entityName = @getMeta('model').prototype.entityName
      filter = @ENTITY_NAME_TO_FILTER_GENERATOR[entityName]
        ids: itemsList

      return Activity.getActivitiesListURL(filter)

    ENTITY_NAME_TO_FILTER_GENERATOR:
      "#{Compound.prototype.entityName}":\
      Handlebars.compile('molecule_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Target.prototype.entityName}":\
      Handlebars.compile('target_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Document.prototype.entityName}":\
      Handlebars.compile('document_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Assay.prototype.entityName}":\
      Handlebars.compile('assay_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{CellLine.prototype.entityName}":\
      Handlebars.compile('_metadata.assay_data.cell_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{glados.models.Tissue.prototype.entityName}":\
      Handlebars.compile('_metadata.assay_data.tissue_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{glados.models.Compound.Drug}":\
      Handlebars.compile('molecule_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')

    # ------------------------------------------------------------------------------------------------------------------
    # Fetching state handling
    # ------------------------------------------------------------------------------------------------------------------
    getItemsFetchingState: -> @getMeta('items_fetching_state')
    getFacetsFetchingState: -> @getMeta('facets_fetching_state')
    setItemsFetchingState: (newFetchingState) ->
      @setMeta('items_fetching_state', newFetchingState)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.ITEMS_FETCHING_STATE_CHANGED)
    setFacetsFetchingState: (newFetchingState) ->
      @setMeta('facets_fetching_state', newFetchingState)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_FETCHING_STATE_CHANGED)
    setInitialFetchingState: ->
      @setMeta('items_fetching_state',
        glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.INITIAL_STATE)
      @setMeta('facets_fetching_state',
        glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.INITIAL_STATE)

    itemsAreReady: ->

      itemsAreReady = @getMeta('items_fetching_state') == \
      glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.ITEMS_READY
      return itemsAreReady

    facetsAreReady: ->

      facetsAreReady = @getMeta('facets_fetching_state') == \
      glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FACETS_READY
      return facetsAreReady

    isReady: -> @itemsAreReady() and @facetsAreReady()

glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS =
  ITEMS_FETCHING_STATE_CHANGED: 'ITEMS_FETCHING_STATE_CHANGED'
  FACETS_FETCHING_STATE_CHANGED: 'FACETS_FETCHING_STATE_CHANGED'

glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  FETCHING_ITEMS: 'FETCHING_ITEMS'
  ITEMS_READY: 'ITEMS_READY'

glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  FETCHING_FACETS: 'FETCHING_FACETS'
  FACETS_READY: 'FACETS_READY'