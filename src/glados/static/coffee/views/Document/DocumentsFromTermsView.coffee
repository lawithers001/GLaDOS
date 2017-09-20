# View that renders a list of resulting documents as paginated cards.
DocumentsFromTermsView = Backbone.View.extend

  initialize: ->
    @collection.on 'do-repaint', @.render, @
    @paginatedView = glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(@collection, @el, 'do-repaint')

  render: ->

    glados.Utils.fillContentForElement $(@el).find('.list-description'),
      term: GlobalVariables.SEARCH_TERM_DECODED