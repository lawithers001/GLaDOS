glados.useNameSpace 'glados',
  Utils:
    # this is to support using dots for nested properties in the list settings
    #for example, if you have the following object
    # a = {
    #    b: {
    #      c: 2
    #       }
    #     }
    # you can use the function like this getNestedValue(a, 'b.c'.split('.'))
    getNestedValue: (nestedObj, nestedComparatorsStr, forceAsNumber=false) ->

      # temporary hack for target bioactivities
      if nestedComparatorsStr == 'num_bioactivities'
        return 'NUMBER'

      nullReturnVal = if forceAsNumber then -Number.MAX_VALUE else glados.Settings.DEFAULT_NULL_VALUE_LABEL

      nestedComparatorsList = nestedComparatorsStr.split('.')
      if nestedComparatorsList.length == 1
        value = nestedObj[(nestedComparatorsList.shift())]
        if not value?
          return nullReturnVal
        if forceAsNumber
          return parseFloat(value)
        else
          return value
      else
        prop = nestedComparatorsList.shift()
        newObj = nestedObj[(prop)]
        if !newObj?
          return nullReturnVal

        return @getNestedValue(newObj, nestedComparatorsList.join('.'))


    # given an model and a list of columns to show, it gives an object ready to be passed to a
    # handlebars template, with the corresponding values for each column
    # handlebars only allow very simple logic, we have to help the template here and
    # give it everything as ready as possible
    getColumnsWithValues: (columns, model) ->

      return columns.map (colDescription) ->

        returnCol = {}
        returnCol.name_to_show = colDescription['name_to_show']

        col_value = glados.Utils.getNestedValue(model.attributes, colDescription.comparator)

        if _.isBoolean(col_value)
          returnCol['value'] = if col_value then 'Yes' else 'No'
        else
          returnCol['value'] = col_value

        if _.has(colDescription, 'parse_function')
          returnCol['value'] = colDescription['parse_function'](col_value)

        returnCol['has_link'] = _.has(colDescription, 'link_base')
        returnCol['is_secondary_link'] = colDescription.secondary_link == true
        returnCol['link_url'] = model.get(colDescription['link_base']) unless !returnCol['has_link']
        if _.has(colDescription, 'image_base_url')
          img_url = model.get(colDescription['image_base_url'])
          returnCol['img_url'] = img_url
        if _.has(colDescription, 'custom_field_template')
          returnCol['custom_html'] = Handlebars.compile(colDescription['custom_field_template'])
            val: returnCol['value']

        # This method should return a value based on the parameter, not modify the parameter
        return returnCol

    #gets the image url from the first column with values that has a 'img_url'
    getImgURL: (columnsWithValues) ->

      for col in columnsWithValues
        if col['img_url']?
          return col['img_url']
      return null

    cachedTemplateFunctions: {}
    # the element must define a data-hb-template, which is the id of the handlebars template to be used
    fillContentForElement: ($element, paramsObj={})->

      templateSelector = '#' + $element.attr('data-hb-template')

      if not glados.Utils.cachedTemplateFunctions[templateSelector]?
        templateFunction = Handlebars.compile($(templateSelector).html())
        glados.Utils.cachedTemplateFunctions[templateSelector] = templateFunction
      else
        templateFunction = glados.Utils.cachedTemplateFunctions[templateSelector]

      $element.html templateFunction(paramsObj)

    # Helper function to prevent links from navigating to an url that is inside the same js page
    # If key_up is true will override for enter listening on links
    # If key_up is false will override for click listening on links
    # callback should be a function that receives the href of the link and knows how to handle it
    getNavigateOnlyOnNewTabLinkEventHandler: (key_up, callback)->
      handler = (event)->
        # Disables link navigation by click or enter, unless it redirects to a non results page
        if $(this).attr("target") != "_blank" and \
          (not key_up or event.keyCode == 13) and \
          not(event.ctrlKey or GlobalVariables.IS_COMMAND_KEY_DOWN)
            event.preventDefault()
            callback($(this).attr("href"))
      return handler

    overrideHrefNavigationUnlessTargetBlank: ($jquery_element, callback)->
      $jquery_element.click(
        glados.Utils.getNavigateOnlyOnNewTabLinkEventHandler(false, callback)
      )
      $jquery_element.keyup(
        glados.Utils.getNavigateOnlyOnNewTabLinkEventHandler(true, callback)
      )

    # for server side collections, it assumes that all the results are already on the client
    pluckFromListItems: (list, propertyName) ->

      if list.allResults?
        return (glados.Utils.getNestedValue(model, propertyName) for model in list.allResults)
      else
        return (glados.Utils.getNestedValue(model.attributes, propertyName) for model in list.models)

    renderLegendForProperty: (property, collection, $legendContainer, enableSelection=true) ->

      if not property.legendModel?
        property.legendModel = new glados.models.visualisation.LegendModel
          property: property
          collection: collection
          enable_selection: enableSelection

      if not property.legendView?
        property.legendView = new LegendView
          model: property.legendModel
          el: $legendContainer
      else
        property.legendView.render()

      $legendContainer.find('line, path').css('fill', 'none')

    getDegreesFromRadians: (radians) -> radians * 180 / Math.PI
