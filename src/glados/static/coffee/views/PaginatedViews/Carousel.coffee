glados.useNameSpace 'glados.views.PaginatedViews',
  Carousel:
    activePage: 1
    initAvailablePageSizes: ->

      if @config.custom_available_page_sizes?
        @AVAILABLE_PAGE_SIZES = @config.custom_available_page_sizes
        @currentPageSize = @AVAILABLE_PAGE_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

      if @config.custom_card_sizes?
        @CURRENT_CARD_SIZES = @config.custom_card_sizes

      else
        @AVAILABLE_PAGE_SIZES ?= (size for key, size of glados.Settings.DEFAULT_CAROUSEL_SIZES)
        @currentPageSize = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

      f = (newPageSize) ->
        @currentPageSize = newPageSize
        @collection.resetPageSize(newPageSize)

      resetPageSizeProxy = $.proxy(f, @)
      thisView = @
      $(window).resize ->
        if GlobalVariables.CURRENT_SCREEN_TYPE_CHANGED
          if thisView.config.custom_available_page_sizes?
            resetPageSizeProxy thisView.AVAILABLE_PAGE_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
          else
            resetPageSizeProxy glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]

    bindCollectionEvents: ->
      @collection.on glados.Events.Collections.SELECTION_UPDATED, @selectionChangedHandler, @

      if @customRenderEvents?
        @collection.on @customRenderEvents, @.render, @

      @collection.on 'reset sort do-repaint', @render, @
      @collection.on 'error', @handleError, @

    getPageEvent: (event) ->
      clicked = $(event.currentTarget)
      currentPage = @collection.getMeta('current_page')
      pageNum = clicked.attr('data-page')

      console.log 'DATA CLICKED', clicked.data().page

      if not @eventForThisView(clicked)
        console.log '?????:'
        return

      if clicked.hasClass('disabled') or parseInt(pageNum) == @activePage
        console.log 'SAME OR DISABLED :'
        return

#     Going backwards

#      console.log 'PAGE NUM', pageNum
#      console.log 'ACTIVE PAGE', @activePage
#      console.log '----'

      console.log 'BACKWARDS?: ', parseInt(pageNum) < parseInt(@activePage) or clicked.attr('data-page') == 'previous'
      if parseInt(pageNum) < parseInt(@activePage) or clicked.attr('data-page') == 'previous'
        console.log 'backwards: ', @activePage
        @activePage = if clicked.hasClass('previous') then @activePage - 1 else pageNum
        @fillPaginators(@activePage)
#       @animateCards(currentPage, paginatorPage)
        return

#     Going forward
      else
        console.log 'FORWARD!'
        @activePage  = if pageNum == 'next' then @activePage + 1 else pageNum

        if parseInt(@activePage) >= parseInt(currentPage)
          @generatePageQueue(parseInt(currentPage), parseInt(@activePage))
          nextPageToLoad = @pageQueue.shift()
          @requestPageInCollection(nextPageToLoad)
        else
          @fillPaginators(@activePage)
  #      @animateCards(currentPage, nextPage)

    generatePageQueue: (startPage, endPage) ->
      @pageQueue = (num for num in [(startPage + 1)..(endPage + 1)])

    initPageQueue: ->
      @pageQueue = [2]

    renderViewState: ->
      isDefaultZoom = @mustDisableReset()
      mustComplicate = @collection.getMeta('complicate_cards_view')
      @isComplicated = isDefaultZoom and mustComplicate
#      activeButton = $(@el).find('.active')
#      activePage = parseInt(activeButton.data().page)

      nextPageToLoad = @pageQueue.shift()

      if nextPageToLoad?
        @requestPageInCollection(nextPageToLoad)

      @fillPaginators(@activePage)
      @fillSelectAllContainer() unless @disableItemsSelection
      if @collection.getMeta('total_pages') == 1
        @hidePaginators()
        @hideFooter()

      @activateSelectors()
      @showPaginatedViewContent()

      glados.views.PaginatedViews.PaginatedViewBase.renderViewState.call(@)

    animateCards: (currentPage, nextPage) ->

      $elem = $(@el).find '.BCK-items-container'
      $elem.show()
      pxToMove = $elem.children('.carousel-card').first().width() * (nextPage - currentPage + 1) * @currentPageSize
      $elem.animate {
        left: '-=' + pxToMove + 'px'
      }

    sendDataToTemplate: ($specificElemContainer, visibleColumns) ->
      customTemplateID =  @collection.getMeta('columns_description').Carousel.CustomItemTemplate
      glados.views.PaginatedViews.PaginatedViewBase.sendDataToTemplate.call(@, $specificElemContainer, visibleColumns,
        customTemplateID)
    # ------------------------------------------------------------------------------------------------------------------
    # Columns initalisation
    # ------------------------------------------------------------------------------------------------------------------
    getDefaultColumns: -> @collection.getMeta('columns_description').Carousel.Default
    getAdditionalColumns: -> @collection.getMeta('columns_description').Carousel.Additional

