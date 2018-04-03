glados.useNameSpace 'glados.models.ScrollSpy',
  ScrollSpyHandler: Backbone.Model.extend


    initialize: ->
      @set('sections', {})
      @set('sectionsQueue', {})

    registerSection: (sectionName, sectionLabel) ->
      sections = @get('sections')

      sections[sectionName] =
        name: sectionName
        label: sectionLabel
        state: glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.NOT_AVAILABLE
        position: _.keys(sections).length
        decided_state: false

      @trigger('change:sections')

    showSection: (sectionName) ->
      sections = @get('sections')
      sections[sectionName].state = glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW
      sections[sectionName].decided_state = true
      @trigger('change:sections')

    hideSection: (sectionName) ->
      sections = @get('sections')
      sections[sectionName].state = glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.NOT_AVAILABLE
      sections[sectionName].decided_state = true
      @trigger('change:sections')

    resetSections: ->
      @set('sections', {})

glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES =
  NOT_AVAILABLE: 'NOT_AVAILABLE'
  SHOW: 'SHOW'