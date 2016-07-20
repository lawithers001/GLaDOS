// Generated by CoffeeScript 1.4.0
var Assay;

Assay = Backbone.RelationalModel.extend({
  idAttribute: 'assay_chembl_id',
  initialize: function() {
    this.on('change', this.fetchRelatedModels, this);
    return this.url = 'https://www.ebi.ac.uk/chembl/api/data/assay/' + this.get('assay_chembl_id') + '.json';
  },
  relations: [
    {
      type: Backbone.HasOne,
      key: 'target',
      relatedModel: 'Target'
    }
  ],
  fetchRelatedModels: function() {
    return this.getAsync('target');
  },
  parse: function(data) {
    var parsed;
    parsed = data;
    parsed.target = data.target_chembl_id;
    return parsed;
  }
});
