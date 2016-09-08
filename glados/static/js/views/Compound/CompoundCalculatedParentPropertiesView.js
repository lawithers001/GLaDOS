// Generated by CoffeeScript 1.4.0
var CompoundCalculatedParentPropertiesView;

CompoundCalculatedParentPropertiesView = CardView.extend(DownloadViewExt).extend({
  initialize: function() {
    this.model.on('change', this.render, this);
    this.model.on('error', this.showCompoundErrorCard, this);
    return this.resource_type = 'Compound';
  },
  render: function() {
    var thisView;
    if (!(this.model.get('molecule_properties') != null)) {
      $('#CalculatedCompoundParentProperties').hide();
      return;
    }
    thisView = this;
    $.each(this.mol_properties, function(key, elem_id) {
      var value;
      value = thisView.model.get('molecule_properties')[key];
      if (value == null) {
        value = '--';
      }
      return $('#' + elem_id).text(value);
    });
    this.initEmbedModal('calculated_properties');
    this.activateModals();
    return this.showVisibleContent();
  },
  mol_properties: {
    'full_mwt': 'Bck-CalcCompProp-MolWt',
    'mw_monoisotopic': 'Bck-CalcCompProp-MolWtM',
    'alogp': 'Bck-CalcCompProp-ALogP',
    'rtb': 'Bck-CalcCompProp-RotBonds',
    'psa': 'Bck-CalcCompProp-PSA',
    'molecular_species': 'Bck-CalcCompProp-Msp',
    'hba': 'Bck-CalcCompProp-HBA',
    'hbd': 'Bck-CalcCompProp-HBD',
    'num_ro5_violations': 'Bck-CalcCompProp-RO5',
    'acd_most_apka': 'Bck-CalcCompProp-APKA',
    'acd_most_bpka': 'Bck-CalcCompProp-BPKA',
    'acd_logp': 'Bck-CalcCompProp-ACDLogP',
    'acd_logd': 'Bck-CalcCompProp-ACDLogD',
    'aromatic_rings': 'Bck-CalcCompProp-AR',
    'heavy_atoms': 'Bck-CalcCompProp-HA',
    'qed_weighted': 'Bck-CalcCompProp-QEDW'
  },
  downloadParserFunction: function(attributes) {
    return attributes.molecule_properties;
  },
  getFilename: function(format) {
    if (format === 'csv') {
      return this.model.get('molecule_chembl_id') + 'CalculatedParentProperties.csv';
    } else if (format === 'json') {
      return this.model.get('molecule_chembl_id') + 'CalculatedParentProperties.json';
    } else {
      return 'file.txt';
    }
  }
});
