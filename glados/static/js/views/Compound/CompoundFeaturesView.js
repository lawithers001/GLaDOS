// Generated by CoffeeScript 1.4.0
var CompoundFeaturesView;

CompoundFeaturesView = CardView.extend({
  initialize: function() {
    this.model.on('change', this.render, this);
    return this.model.on('error', this.showCompoundErrorCard, this);
  },
  render: function() {
    this.renderProperty('Bck-MolType', 'molecule_type');
    this.renderProperty('Bck-RuleOfFive', 'ro5');
    this.renderProperty('Bck-FirstInClass', 'first_in_class');
    this.renderProperty('Bck-Chirality', 'chirality');
    this.renderProperty('Bck-Prodrug', 'prodrug');
    this.renderProperty('Bck-Oral', 'oral');
    this.renderProperty('Bck-Parenteral', 'parenteral');
    this.renderProperty('Bck-Topical', 'topical');
    this.renderProperty('Bck-BlackBox', 'black_box_warning');
    this.renderProperty('Bck-Availability', 'availability_type');
    $(this.el).children('.card-preolader-to-hide').hide();
    $(this.el).children(':not(.card-preolader-to-hide, .card-load-error)').show();
    this.initEmbedModal('molecule_features');
    this.renderModalPreview();
    return this.activateTooltips();
  },
  renderProperty: function(div_id, property) {
    var property_div;
    property_div = $(this.el).find('#' + div_id);
    return property_div.html(Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-IconContainer').html())({
      active_class: this.getMolFeatureDetails(property, 0),
      filename: this.getMolFeatureDetails(property, 1),
      tooltip: this.getMolFeatureDetails(property, 2),
      description: this.getMolFeatureDetails(property, 3),
      tooltip_position: this.getMolFeatureDetails(property, 4)
    }));
  },
  getMolFeatureDetails: function(feature, position) {
    return this.molFeatures[feature][this.model.get(feature)][position];
  },
  molFeatures: {
    'molecule_type': {
      'Small molecule': ['active', 'mt_small_molecule', 'Molecule Type: small molecule', 'Small Molecule', 'top'],
      'Antibody': ['active', 'mt_antibody', 'Molecule Type: Antibody', 'Antibody', 'top'],
      'Enzyme': ['active', 'mt_enzyme', 'Molecule Type: Enzyme', 'Enzyme', 'top']
    },
    'first_in_class': {
      '-1': ['', 'first_in_class', 'First in Class: Undefined', 'First in Class', 'top'],
      '0': ['', 'first_in_class', 'First in Class: No', 'First in Class', 'top'],
      '1': ['active', 'first_in_class', 'First in Class: Yes', 'First in Class', 'top']
    },
    'chirality': {
      '-1': ['', 'chirality_0', 'Chirality: Undefined', 'Chirality: Undefined', 'top'],
      '0': ['active', 'chirality_0', 'Chirality: Racemic Mixture', 'Racemic Mixture', 'top'],
      '1': ['active', 'chirality_1', 'Chirality: Single Stereoisomer', 'Single Stereoisomer', 'top'],
      '2': ['', 'chirality_1', 'Chirality: Achiral Molecule', 'Achiral Molecule', 'top']
    },
    'prodrug': {
      '-1': ['', 'prodrug', 'Prodrug: Undefined', 'Prodrug', 'top'],
      '0': ['', 'prodrug', 'Prodrug: No', 'Prodrug', 'top'],
      '1': ['active', 'prodrug', 'Prodrug: Yes', 'Prodrug', 'top']
    },
    'oral': {
      'true': ['active', 'oral', 'Oral: Yes', 'Oral', 'bottom'],
      'false': ['', 'oral', 'Oral: No', 'Oral', 'bottom']
    },
    'parenteral': {
      'true': ['active', 'parenteral', 'Parenteral: Yes', 'Parenteral', 'bottom'],
      'false': ['', 'parenteral', 'Parenteral: No', 'Parenteral', 'bottom']
    },
    'topical': {
      'true': ['active', 'topical', 'Topical: Yes', 'Topical', 'bottom'],
      'false': ['', 'topical', 'Topical: No', 'Topical', 'bottom']
    },
    'black_box_warning': {
      '0': ['', 'black_box', 'Black Box: No', 'Black Box', 'bottom'],
      '1': ['active', 'black_box', 'Black Box: Yes', 'Black Box', 'bottom']
    },
    'availability_type': {
      '-1': ['', 'availability_0', 'Availability: Undefined', 'Availability: Undefined', 'bottom'],
      '0': ['active', 'availability_0', 'Availability: Discontinued', 'Discontinued', 'bottom'],
      '1': ['active', 'availability_1', 'Availability: Prescription Only', 'Prescription Only', 'bottom'],
      '2': ['active', 'availability_2', 'Availability: Over the Counter', 'Over the Counter', 'bottom']
    },
    'ro5': {
      'true': ['active', 'rule_of_five', 'Rule Of Five: Yes', 'Rule Of Five', 'top'],
      'false': ['', 'rule_of_five', 'Rule Of Five: No', 'Rule Of Five', 'top']
    }
  }
});
