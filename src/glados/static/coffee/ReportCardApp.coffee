glados.useNameSpace 'glados',
  ReportCardApp: class ReportCardApp

    @init = ->
      @scrollSpyHandler = new glados.models.ScrollSpy.ScrollSpyHandler
      ScrollSpyHelper.initializeScrollSpyPinner()
      new glados.views.ScrollSpy.ScrollSpyView
        el: $('.BCK-ScrollSpy')
        model: @scrollSpyHandler


    @hideSection = (sectionID) ->
      @scrollSpyHandler.hideSection(sectionID)
      $('#' + sectionID).hide()

    @showSection = (sectionID) ->
      @scrollSpyHandler.showSection(sectionID)
      $('#' + sectionID).show()

    @registerSection = (sectionID, sectionLabel) ->
      @scrollSpyHandler.registerSection(sectionID, sectionLabel)

    # you can provide chembld iD or a model already created
    @initMiniReportCard = (Entity, $containerElem, chemblID, model, customTemplate, additionalTemplateParams={},
    fetchModel=true, customColumns)->

      if model?
        model = model
      else
        model = new Entity({id: chemblID})

      view = new glados.views.MiniReportCardView
        el: $containerElem
        model: model
        entity: Entity
        custom_template: customTemplate
        additional_params: additionalTemplateParams
        custom_columns: customColumns

      if not fetchModel
        view.render()
      else
        model.fetch()
