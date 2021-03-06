glados.useNameSpace 'glados.views.Browsers',
  QueryEditorView: Backbone.View.extend

    initialize: ->

      @renderBaseStructure()
      @collection.on 'request', @updateRenderedQuery, @
      @collection.on 'request', @updateQueryString, @

    events:
      'click .BCK-toggle-query-container': 'toggleQueryContainer'
      'click .BCK-toggle-queryStringEditor': 'toggleQuerystringEditor'
      'change .BCK-code-style-selector': 'selectCodeStyle'
      'input propertychange .BCK-querystring-text-area': 'handleQueryStringChange'
      'click .BCK-apply-changes': 'applyQueryStringChanges'

    codeStyles:
      CURL: 'cURL'
      RAW: 'Raw'

    renderBaseStructure: ->

      showQueryStringEditor = @collection.getMeta('use_custom_query') and not @collection.customQueryIsFullQuery()

      codeStyles = _.values(@codeStyles)
      @selectedCodeStyle = codeStyles[0]
      glados.Utils.fillContentForElement $(@el),
        selected_code_style: @selectedCodeStyle
        code_styles: codeStyles[1..]
        show_querystring_editor: showQueryStringEditor

      $queryContainer = $(@el).find('.BCK-toggle-query-container')
      @queryContainerOpen = $queryContainer.hasClass('open')

      $queryEditorContainer = $(@el).find('.BCK-querystring-container')
      @queryStringEditorOpen = $queryEditorContainer.hasClass('open')

      $(@el).find('select').material_select()
      $copyButtonContainer = $(@el).find('.BCK-copy-button')
      @$copyButton = ButtonsHelper.createAndAppendCopyButton($copyButtonContainer)

      $queryStringTextArea = $(@el).find('.BCK-querystring-text-area')
      $queryStringTextArea.bind('input propertychange', @handleQueryStringChange.bind(@))
      @updateQueryString()

    #-------------------------------------------------------------------------------------------------------------------
    # Query String
    #-------------------------------------------------------------------------------------------------------------------
    handleQueryStringChange: ->

      $queryStringTextArea = $(@el).find('.BCK-querystring-text-area')
      currentValue =  $queryStringTextArea.val()
      $applyChangesBtn = $(@el).find('.BCK-apply-changes')
      if currentValue != @previousQueryString
        $applyChangesBtn.removeClass('disabled')
        @previousQueryString = currentValue
      else
        $applyChangesBtn.addClass('disabled')

    updateQueryString: ->

      $queryStringTextArea = $(@el).find('.BCK-querystring-text-area')
      $applyChangesBtn = $(@el).find('.BCK-apply-changes')
      $applyChangesBtn.addClass('disabled')
      currentQueryString = @collection.getMeta('custom_query')
      @previousQueryString = currentQueryString
      $queryStringTextArea.val(currentQueryString)

    updateRenderedQuery: ->

      $queryContainer = $(@el).find('.BCK-query')
      latestRequest = @collection.getMeta('latest_request_data')
      latestRequestStr = JSON.stringify(latestRequest, null, 2)

      if @selectedCodeStyle == @codeStyles.RAW

        indexName = @collection.getMeta('index_name')
        templateParams =
          index_name: @collection.getMeta('index_name')
          query: latestRequestStr

        textToCopy = "Index Name: #{indexName}\nQuery:\n#{latestRequestStr}"
        glados.Utils.fillContentForElement($queryContainer, templateParams,
          customTemplate='Handlebars-Common-QueryEditor-Query')

      else

        templateParams =
          url: @collection.getURL()
          query: latestRequestStr

        glados.Utils.fillContentForElement($queryContainer, templateParams,
          customTemplate='Handlebars-Common-QueryEditor-CURL')

        textToCopy = $queryContainer.find('pre').text()

      ButtonsHelper.updateCopyDataOfButton(@$copyButton, textToCopy)

    toggleQuerystringEditor: ->

      $container = $(@el).find('.BCK-querystring-container')
      $toggler = $(@el).find('.BCK-toggle-queryStringEditor')
      @queryStringEditorOpen = not @queryStringEditorOpen
      @toggleContainer($container, @queryStringEditorOpen, 'Hide Querystring', 'Edit Querystring', $toggler)

    applyQueryStringChanges: ->

      $applyChangesBtn = $(@el).find('.BCK-apply-changes')
      if $applyChangesBtn.hasClass('disabled')
        return

      $queryStringTextArea = $(@el).find('.BCK-querystring-text-area')
      currentValue =  $queryStringTextArea.val()
      @collection.setMeta('custom_query', currentValue)
      @collection.clearAllFacetsSelections() # remember that this clears the facets and then does the fetch

    #-------------------------------------------------------------------------------------------------------------------
    # Full Query
    #-------------------------------------------------------------------------------------------------------------------
    selectCodeStyle: (event) ->

      selectionValue = $(event.currentTarget).val()
      if selectionValue == ''
        return

      @selectedCodeStyle = selectionValue
      @updateRenderedQuery()

    toggleQueryContainer: ->

      $container = $(@el).find('.BCK-query-container')
      $toggler = $(@el).find('.BCK-toggle-query-container')
      @queryContainerOpen = not @queryContainerOpen
      @toggleContainer($container, @queryContainerOpen, 'Hide Full Query', 'Show Full Query', $toggler)

    toggleContainer: ($container, isNowOpen, hideText, showText, $toggler) ->

      if isNowOpen
        $container.removeClass('closed')
        $container.addClass('open')
        $toggler.text(hideText)
      else
        $container.removeClass('open')
        $container.addClass('closed')
        $toggler.text(showText)






