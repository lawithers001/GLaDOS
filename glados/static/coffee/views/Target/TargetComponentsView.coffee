# View that renders the Target Components section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetComponentsView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Target'

  render: ->

    if @model.get('target_components').length == 0
      $('#TargetComponents').hide()
      $('#TargetComponents').next().hide()
      $(@el).hide()
      return

    @fill_template('BCK-Components-large')
    @fill_template('BCK-Components-small')

    # until here, all the visible content has been rendered.
    @showVisibleContent()
    @initEmbedModal('components')
    @activateModals()

  fill_template: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      components: @model.get('target_components')