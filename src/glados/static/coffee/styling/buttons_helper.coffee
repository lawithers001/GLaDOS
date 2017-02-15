class ButtonsHelper

  # ------------------------------------------------------------
  # Download buttons
  # ------------------------------------------------------------

  ### *
    * @param {JQuery} elem button that triggers the download
    * @param {String} filename Name that you want for the downloaded file
    * @param {tolltip} Tooltip that you want for the button
    * @param {String} data data that is going to be downloaded
  ###
  @initDownloadBtn = (elem, filename, tooltip, data)->
      elem.attr('download', filename,)
      elem.addClass('tooltipped')
      elem.attr('data-tooltip', tooltip)
      elem.attr('href', 'data:text/html,' + data)

  ### *
    * Handles the copy event
    * it gets the information from the context, It doesn't use a closure to be faster
  ###
  @handleCopy = ->

    clipboard.copy($(@).attr('data-copy'));
    tooltip_id = $(@).attr('data-tooltip-id')
    tooltip = $('#' + tooltip_id)

    if $( window ).width() <= MEDIUM_WIDTH
      tooltip.hide()
      Materialize.toast('Copied!', 1000)
    else
      tooltip.find('span').text('Copied!')

    console.log('copied!')

  @initCopyButton = (elem, tooltip, data) ->

    copy_btn = elem
    copy_btn.addClass('tooltipped')
    copy_btn.attr('data-tooltip', tooltip)
    copy_btn.attr('data-copy', data )

    copy_btn.click ButtonsHelper.handleCopy


  # ------------------------------------------------------------
  # Cropped container
  # ------------------------------------------------------------

  @expand = (elem) ->
    elem.removeClass("cropped")
    elem.addClass("expanded")

  @contract = (elem) ->
    elem.removeClass("expanded")
    elem.addClass("cropped")

  @setMoreText = (elem) ->

    $(elem).text('more...')

  @setLessText = (elem) ->

    $(elem).text('less...')



  ### *
    * @param {JQuery} elem element that is going to be toggled
    * @param {JQuery} buttons element that contains the buttons that activate this..
    * @return {Function} function that toggles the cropped container
  ###
  @toggleCroppedContainerWrapper = (elem, buttons) ->


    # this toggles the div elements to show or hide all the contents.
    toggleCroppedContainer = ->

      console.log 'toggle cropped container!'

      if elem.hasClass( "expanded" )
        ButtonsHelper.contract(elem)
        ButtonsHelper.setMoreText($(this))
        buttons.removeClass('cropped-container-btns-exp')
      else
        ButtonsHelper.expand(elem)
        ButtonsHelper.setLessText($(this))
        buttons.addClass('cropped-container-btns-exp')

    return toggleCroppedContainer


  ### *
    * Initializes the cropped container on the elements of the class 'cropped-container'
  ###
  @initCroppedContainers = ->

    f = _.debounce( ->

      $('.cropped-container').each ->

        activator = $(this).find('a[data-activates]')
        activated = $('#' + activator.attr('data-activates'))
        buttons = $(this).find('.cropped-container-btns')

        # don't bother to activate the buttons if no elements are overflowing
        overflow = false
        heightLimit = activated.offset().top + activated.height()


        activated.children().each ->

          childHeightLimit = $(this).offset().top + $(this).height()
          if childHeightLimit > heightLimit
            overflow = true
            return false

        if overflow

          if !activator.hasClass('toggler-bound')
            console.log 'binding function'
            toggler = ButtonsHelper.toggleCroppedContainerWrapper(activated, buttons)
            activator.addClass('toggler-bound')
            activator.click(toggler)

          activator.show()
          console.log 'overflow!!!'
        else
          activator.hide()
    , 300)

    $(window).resize f

    f()



  # ------------------------------------------------------------
  # Expandable Menu
  # ------------------------------------------------------------

  @showExpandableMenu = (activator, elem) ->

    activator.html('<i class="material-icons">remove</i>')
    elem.slideDown(300)

  @hideExpandableMenu = (activator, elem) ->

    activator.html('<i class="material-icons">add</i>')
    elem.slideUp(300)

  @hideExpandableMenuWrapper = (activator, elem_id_list) ->

    toggleExpandableMenu = ->

      $.each elem_id_list, (index, elem_id) ->

        elem = $('#' + elem_id)

        ButtonsHelper.hideExpandableMenu(activator, elem)

    return toggleExpandableMenu

  ### *
  * @param {JQuery} activator element that activates toggles the expandable menu
    * @param {Array} elem_id_list list of menu elements that are going to be shown
    * @return {Function} function that toggles the expandable menus
  ###
  @toggleExpandableMenuWrapper = (activator, elem_id_list) ->

    toggleExpandableMenu = ->

      $.each elem_id_list, (index, elem_id) ->

        elem = $('#' + elem_id)

        if elem.css('display') == 'none'
          ButtonsHelper.showExpandableMenu(activator, elem)
        else
          ButtonsHelper.hideExpandableMenu(activator, elem)

    return toggleExpandableMenu

  ### *
    *  Initializes the toggler on the elements of the class 'expandable-menu'
  ###
  @initExpendableMenus = ->

    $('.expandable-menu').each ->

      currentDiv = $(this)
      activators = $(this).find('a[data-activates]')

      activators.each ->

        activator = $( this )
        activated_list = activator.attr('data-activates').split(',')

        toggler = ButtonsHelper.toggleExpandableMenuWrapper(activator, activated_list)
        activator.click(toggler)

        #hide when click outside the menu
        hider = ButtonsHelper.hideExpandableMenuWrapper(activator, activated_list)
        activated_list_selectors = ''
        $.each activated_list, (index, elem_id) ->
          activated_list_selectors += '#' + elem_id + ', '


        $('body').click (e) ->
          if not $.contains(currentDiv[0], e.target)
            hider()

        activator.click (event) ->
          event.stopPropagation()


  # ------------------------------------------------------------
  # cropped text field
  # ------------------------------------------------------------


  ### *
    *  Initializes the cropped container on the elements of the class 'cropped-text-field'
    * It is based on an input field to show the information
  ###
  @initCroppedTextFields = ->

    $('.cropped-text-field').each ->

      currentDiv = $(this)
      input_field = $(this).find('input')
      input_field.click ->
        input_field.val(currentDiv.attr('data-original-value'))
        input_field.select()

      # this is to allow to easily modify the content of the input if it needs to be cropped
      $(this).attr('data-original-value', input_field.attr('value'))

      input_field.focusout ->
        ButtonsHelper.cropTextIfNecessary(currentDiv)

      $( window ).resize ->

        if currentDiv.is(':visible')
          ButtonsHelper.cropTextIfNecessary(currentDiv)


      ButtonsHelper.cropTextIfNecessary(currentDiv)

  ### *
    * Decides if the input contained in the div is overlapping and the ellipsis must be shown.
    * if it is overlapping, shows the ellipsis and crops the text, if not, it doesn't show the ellipsis
    * and shows all the text in the input
    * @param {JQuery} input_div element that contains the ellipsis and the input
  ###
  @cropTextIfNecessary = (input_div)->

    input_field = input_div.find('input')[0]

    originalInputValue = input_div.attr('data-original-value')
    # don't bother to do anything if there is no text in the input.
    if originalInputValue == undefined
      return

    input_field.value = originalInputValue

    charLength = ( input_field.scrollWidth / originalInputValue.length )
    numVisibleChars = Math.round(input_field.clientWidth / charLength)


    if input_field.scrollWidth > input_field.clientWidth
      # overflow
      partSize = ( numVisibleChars / 2 ) - 2
      shownValue = originalInputValue.substring(0, partSize) + ' ... ' +
                   originalInputValue.substring(
                     originalInputValue.length - partSize + 2, originalInputValue.length)

      # remember that the original value is stored in the input_div's 'data-original-value' attribute
      input_field.value = shownValue

    else
      input_field.value = originalInputValue


  # ------------------------------------------------------------
  # expandable text input
  # ------------------------------------------------------------



  @createExpandableInput = (input_element)->
    if not input_element instanceof jQuery
      $input_element = $(input_element)
    else
      $input_element = $(input_element)
    expanded_area_id = $input_element.attr('id')+'-expanded'
    if $input_element.is("input")
      $input_element.after('<textarea id="'+expanded_area_id+'" style="z-index:1; display: none; position:relative; background: white">')
      initial_width = $input_element.width()
      $expandend_element = $('#'+expanded_area_id)
      updateVals = ()->
        cur_val = $input_element.val()
        $expandend_element.html(cur_val)
      isInputOverflowing = ()->
        overflow = ($input_element[0].scrollWidth > initial_width)
        return overflow

      adjustExpandedHeight = ()->
        max_height = $(window).height()*0.8
        min_h = Math.min(max_height,$expandend_element[0].scrollHeight)
        console.log($expandend_element[0].clientHeight,$expandend_element[0].scrollHeight,)
        $expandend_element.height(min_h)

      onkeyup = () ->
        updateVals()
        if isInputOverflowing()
          $input_element.hide()
          $expandend_element.show()
          $expandend_element.focus()
          adjustExpandedHeight()

      expandedKeyup = ()->
        adjustExpandedHeight()

      onchange = ()->
        return
      $input_element.change(onchange)
      $input_element.keyup(onkeyup)
      $expandend_element.keyup(expandedKeyup)
    else
      console.log("WARNING: could not obtain a valid input element to create an expandable input. input_element:",
        input_element)










