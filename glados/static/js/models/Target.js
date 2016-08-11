// Generated by CoffeeScript 1.4.0
var Target;

Target = Backbone.RelationalModel.extend({
  idAttribute: 'target_chembl_id',
  initialize: function() {
    this.on('change', this.getProteinTargetClassification, this);
    return this.url = 'https://wwwdev.ebi.ac.uk/chembl/api/data/target/' + this.get('target_chembl_id') + '.json';
  },
  getProteinTargetClassification: function() {
    var comp, comp_url, component_id, target, target_components, _i, _len, _results;
    target_components = this.get('target_components');
    if ((target_components != null) && !this.get('protein_classifications_loaded')) {
      this.set('protein_classifications', {}, {
        silent: true
      });
      target = this;
      _results = [];
      for (_i = 0, _len = target_components.length; _i < _len; _i++) {
        comp = target_components[_i];
        component_id = comp['component_id'];
        comp_url = 'https://www.ebi.ac.uk/chembl/api/data/target_component/' + component_id + '.json';
        _results.push($.get(comp_url).done(function(data) {
          var prot_class, prot_class_dict, prot_class_id, prot_class_url, protein_classifications, _j, _len1, _results1;
          protein_classifications = data['protein_classifications'];
          _results1 = [];
          for (_j = 0, _len1 = protein_classifications.length; _j < _len1; _j++) {
            prot_class = protein_classifications[_j];
            prot_class_id = prot_class['protein_classification_id'];
            prot_class_dict = target.get('protein_classifications');
            if (!(prot_class_dict[prot_class_id] != null)) {
              prot_class_dict[prot_class_id] = "";
              prot_class_url = 'https://www.ebi.ac.uk/chembl/api/data/protein_class/' + prot_class_id + '.json';
              _results1.push($.get(prot_class_url).done(function(data) {
                var num;
                prot_class_dict[data['protein_class_id']] = (function() {
                  var _k, _results2;
                  _results2 = [];
                  for (num = _k = 1; _k <= 8; num = ++_k) {
                    if (data['l' + num] != null) {
                      _results2.push(data['l' + num]);
                    }
                  }
                  return _results2;
                })();
                target.set('protein_classifications_loaded', true, {
                  silent: true
                });
                return target.trigger('change');
              }).fail(function() {
                return console.log('failed2!');
              }));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        }).fail(function() {
          return console.log('failed!');
        }));
      }
      return _results;
    }
  }
});
