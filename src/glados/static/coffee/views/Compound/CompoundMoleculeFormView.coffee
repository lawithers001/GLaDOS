# This view renders materialize column with a card that contains the a compound
# in the molecule forms section.
CompoundMoleculeFormView = Backbone.View.extend

  tagName: 'div'
  className: 'col s6 m4 l3'

  initialize: ->
    @model.on 'change', @.render, @
    @resource_type = 'Compound'

  render: ->

    colour = if @model.get('molecule_chembl_id') == GlobalVariables.CHEMBL_ID then 'teal lighten-5' else ''

    $(this.el).html Handlebars.compile($('#Handlebars-Compound-AlternateFormCard').html())
      molecule_chembl_id: @model.get('molecule_chembl_id')
      report_card_url: @model.get('report_card_url')
      image_url: @model.get('image_url')
      colour: colour

    return @