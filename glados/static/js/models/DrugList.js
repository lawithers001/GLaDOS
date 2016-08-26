// Generated by CoffeeScript 1.4.0
var DrugList;

DrugList = PaginatedCollection.extend({
  model: Drug,
  parse: function(data) {
    data.page_meta.records_in_page = data.molecules.length;
    this.resetMeta(data.page_meta);
    return data.molecules;
  },
  initialize: function() {
    return this.meta = {
      server_side: true,
      base_url: 'https://www.ebi.ac.uk/chembl/api/data/molecule.json',
      page_size: 10,
      current_page: 1,
      to_show: [],
      columns: [
        {
          'name_to_show': 'ChEMBL ID',
          'comparator': 'molecule_chembl_id',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort',
          'link_base': '/compound_report_card/$$$',
          'image_base_url': 'https://www.ebi.ac.uk/chembl/api/data/image/$$$.svg'
        }, {
          'name_to_show': 'Molecule Type',
          'comparator': 'molecule_type',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort'
        }, {
          'name_to_show': 'Name',
          'comparator': 'pref_name',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort'
        }, {
          'name_to_show': 'Max Phase',
          'comparator': 'max_phase',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort'
        }
      ]
    };
  }
});
