// Generated by CoffeeScript 1.4.0
var ApprovedDrugsClinicalCandidatesView;

ApprovedDrugsClinicalCandidatesView = CardView.extend({
  initialize: function() {
    this.collection.on('reset', this.render, this);
    return this.resource_type = 'Target';
  },
  render: function() {
    this.fill_template('ADCCTable-large');
    this.fill_template('ADCCUL-small');
    return this.showVisibleContent();
  },
  fill_template: function(div_id) {
    var adcc, div, new_row_cont, template, _i, _len, _ref, _results;
    div = $(this.el).find('#' + div_id);
    template = $('#' + div.attr('data-hb-template'));
    _ref = this.collection.models;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      adcc = _ref[_i];
      new_row_cont = Handlebars.compile(template.html())({
        molecule_chembl_id: adcc.get('molecule_chembl_id'),
        pref_name: adcc.get('pref_name'),
        mechanism_of_action: adcc.get('mechanism_of_action'),
        max_phase: adcc.get('max_phase')
      });
      _results.push(div.append($(new_row_cont)));
    }
    return _results;
  }
});
