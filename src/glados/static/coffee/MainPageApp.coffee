# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    new glados.views.MainPage.CentralCardView
      el: $('.BCK-Central-Card')

    databaseInfo = new glados.models.MainPage.DatabaseSummaryInfo()
    console.log 'databaseInfo: ', databaseInfo
    new glados.views.MainPage.DatabaseSummaryView
      model: databaseInfo
      el: $('.BCK-Database-summary-info')

    databaseInfo.fetch()

    tweetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    tweetsList.initURL()
    $tweetsElem = $('.BCK-Tweets-container')
    glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(tweetsList, $tweetsElem, 'do-repaint')

    tweetsList.fetch()

    MainPageApp.initPapersPerYear()

# ---------------- Aggregation -------------- #
  @getDocumentsPerYearAgg = (defaultInterval=1) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'
      template_data: {}

    aggsConfig =
      aggs:
        documentsPerYear:
          type: glados.models.Aggregations.Aggregation.AggTypes.HISTOGRAM
          field: 'year'
          default_interval_size: defaultInterval
          min_interval_size: 1
          max_interval_size: 10
          aggs:
            split_series_agg:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: 'journal'
              size: 10

    allDocumentsByYear = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.DOCUMENT_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return allDocumentsByYear


  @initPapersPerYear = ->

    allDocumentsByYear = MainPageApp.getDocumentsPerYearAgg()
    type = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('DocumentAggregation', 'YEAR')
    barsColourScale = type.colourScale

    histogramConfig =
      bars_colour_scale: barsColourScale
      stacked_histogram: true
      rotate_x_axis_if_needed: false
      big_size: true
      paint_axes_selectors: true
      properties:
        count: type
      initial_property_x: 'count'
      initial_property_z: 'Journal'
      x_axis_options: ['count']
      x_axis_min_columns: 1
      x_axis_max_columns: 40
      x_axis_initial_num_columns: 40
      x_axis_prop_name: 'documentsPerYear'
      sub_buckets_property_name: 'split_series_agg'
      title: 'Documents by Year'

    new glados.views.Visualisation.HistogramView
      el: $('.BCK-MainHistogramContainer')
      config: histogramConfig
      model: allDocumentsByYear


    allDocumentsByYear.fetch()

