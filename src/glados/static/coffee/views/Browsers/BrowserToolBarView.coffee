glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserToolBarView: Backbone.View.extend

    events:
      'click .BCK-toggle-hide-filters': 'toggleHideFilters'

    initialize: ->

      @browserView = arguments[0].menu_view
      @collection.on 'reset', @checkIfNoItems, @

    # ------------------------------------------------------------------------------------------------------------------
    # Render
    # ------------------------------------------------------------------------------------------------------------------
    hideAll: ->
      $(@el).hide()

    checkIfNoItems: ->

      totalRecords = @collection.getMeta('total_records')
      if totalRecords == 0
        @hideAll()
        return true
      return false

    wakeUp: ->

    # ------------------------------------------------------------------------------------------------------------------
    # Hide Filters
    # ------------------------------------------------------------------------------------------------------------------
    toggleHideFilters: ->

      $opener = $(@el).find('.BCK-toggle-hide-filters')
      $icon = $opener.find('i')

      if $opener.attr('data-filters-open') == 'yes'
        $icon.removeClass('fa-chevron-left')
        $icon.addClass('fa-chevron-right')
        $opener.attr('data-filters-open', 'no')
        @browserView.hideFilters()
      else
        $icon.addClass('fa-chevron-left')
        $icon.removeClass('fa-chevron-right')
        $opener.attr('data-filters-open', 'yes')
        @browserView.showFilters()
