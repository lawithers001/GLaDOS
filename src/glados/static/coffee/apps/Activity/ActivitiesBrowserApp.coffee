glados.useNameSpace 'glados.apps.Activity',
  ActivitiesBrowserApp: class ActivitiesBrowserApp

    @init = ->

      router = new glados.apps.Activity.ActivitiesRouter
      Backbone.history.start()

    @initBrowser = ->

      $mainContainer = $('.BCK-main-container')
      $mainContainer.show()

      $mainContainer.children().hide()
      $mainContainer.find('.BCK-browser').show()

      filter = URLProcessor.getFilter()
      actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: actsList
        el: $browserContainer

      actsList.fetch()

    @initMatrixFSView = (sourceEntity) ->

      filter = URLProcessor.getFilter()
      $mainContainer = $('.BCK-main-container')
      $mainContainer.show()

      $mainContainer.children().hide()
      $matrixFSContainer = $mainContainer.find('.BCK-matrix-full-screen')
      $matrixFSContainer.show()

      entityName = 'Compounds'
      filterProperty = 'molecule_chembl_id'
      aggList = ['molecule_chembl_id', 'target_chembl_id']

      ctm = new glados.models.Activity.ActivityAggregationMatrix
        filter_property: filterProperty
        aggregations: aggList

      config = MatrixView.getDefaultConfig entityName

      $matrixContainer = $matrixFSContainer.find('.BCK-CompTargetMatrix')
      console.log('FS: init matrix from ' + sourceEntity)
      console.log 'config: ', config
      console.log 'filter: ', filter
      new MatrixView
        model: ctm
        el: $matrixContainer
        config: config

      allItemsIDs = ['CHEMBL59', 'CHEMBL1557', 'CHEMBL457419']
      ctm.set('chembl_ids', allItemsIDs)
      ctm.fetch()

    @initMatrixCellMiniReportCard: ($containerElem, d, compoundsAreRows=true) ->

      summary = new glados.models.Activity.ActivityAggregation
        activity_count: d.activity_count
        pchembl_value_avg: d.pchembl_value_avg
        molecule_chembl_id: if compoundsAreRows then d.row_id else d.col_id
        target_chembl_id: if compoundsAreRows then d.col_id else d.row_id
        pchembl_value_max: d.pchembl_value_max

      new glados.views.Activity.ActivityAggregationView
        el: $containerElem
        model: summary