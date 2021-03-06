# This model handles the communication with the server for server side downloads.
glados.useNameSpace 'glados.models.ServerSideDownloads',

  DownloadModel: Backbone.Model.extend

    initialize: -> @setState(glados.models.ServerSideDownloads.DownloadModel.states.INITIAL_STATE)

    #-------------------------------------------------------------------------------------------------------------------
    # starting download
    #-------------------------------------------------------------------------------------------------------------------
    startServerSideDownload: (desiredFormat) ->

      downloadParams = @getDownloadParams(desiredFormat)
      generateDownload = glados.doCSRFPost(glados.Settings.GENERATE_SERVER_SIDE_DOWNLOAD_ENDPOINT, downloadParams)

      thisModel = @
      generateDownload.then (response) ->
        thisModel.set('download_id', response.download_id)
        thisModel.set('progress', 0)
        thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD)

      generateDownload.fail (response) ->                                                      
        thisModel.set('error_msg', response.responseText)
        thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE)

    getDownloadParams: (desiredFormat) ->

      collection = @get('collection')
      requestData = collection.getRequestData()
      download_columns_group = collection.getMeta('download_columns_group')

      ssSearchModel = collection.getMeta('sssearch_model')
      return {
        index_name: collection.getMeta('index_name')
        query: JSON.stringify(requestData.query)
        format: desiredFormat
        context_id: if ssSearchModel? then ssSearchModel.get('search_id') else undefined
        download_columns_group: if download_columns_group? then download_columns_group else undefined
      }

    #-------------------------------------------------------------------------------------------------------------------
    # Check download progress
    #-------------------------------------------------------------------------------------------------------------------
    getProgressURL: -> "#{glados.Settings.GLADOS_BASE_PATH_REL}glados_api/shared/downloads/download_status/#{@get('download_id')}"
    checkDownloadProgressPeriodically: ->

      progressURL = @getProgressURL()
      thisModel = @
      getProgress = $.get(progressURL)

      getProgress.then (response) ->

        status = response.status
        if status == 'ERROR'

          thisModel.set('error_msg', response.msg)
          thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE)

        else if status == 'QUEUED'

          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 1000)

        else if status == 'PROCESSING'

          thisModel.set('progress', response.percentage)
          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 1000)

        else if status == 'DELETING'

          thisModel.set('progress', '--')
          thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.DELETING)
          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 1000)

        else if status == 'FINISHED'

          thisModel.set('expires', response.expires)
          thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.FINISHED)

        else

          setTimeout(thisModel.checkDownloadProgressPeriodically.bind(thisModel), 1000)

      getProgress.fail (response) ->

        thisModel.set('error_msg', response.statusText)
        thisModel.setState(glados.models.ServerSideDownloads.DownloadModel.states.ERROR_STATE)

    #-------------------------------------------------------------------------------------------------------------------
    # Getting download final url
    #-------------------------------------------------------------------------------------------------------------------
    getDownloadURL: -> "#{glados.Settings.GLADOS_BASE_PATH_REL}dynamic-downloads/#{@get('download_id')}.gz"

    #-------------------------------------------------------------------------------------------------------------------
    # State handling
    #-------------------------------------------------------------------------------------------------------------------
    getState: -> @get('state')
    setState: (newState) ->
      @set('state', newState)
      if newState == glados.models.ServerSideDownloads.DownloadModel.states.GENERATING_DOWNLOAD
        @checkDownloadProgressPeriodically()

glados.models.ServerSideDownloads.DownloadModel.states =
  INITIAL_STATE: 'INITIAL_STATE'
  ERROR_STATE: 'ERROR_STATE'
  GENERATING_DOWNLOAD: 'GENERATING_DOWNLOAD'
  FINISHED: 'FINISHED'
  DELETING: 'DELETING'