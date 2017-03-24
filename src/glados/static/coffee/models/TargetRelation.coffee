TargetRelation = Backbone.Model.extend({})

TargetRelation.COLUMNS = {
  CHEMBL_ID:{
    'name_to_show': 'ChEMBL ID'
    'comparator': 'target_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base': 'report_card_url'
  }
  RELATIONSHIP:{
    'name_to_show': 'Relationship'
    'comparator': 'relationship'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PREF_NAME:{
    'name_to_show': 'Pref Name'
    'comparator': 'pref_name'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  TARGET_TYPE:{
    'name_to_show': 'Target Type'
    'comparator': 'target_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
}

TargetRelation.ID_COLUMN = TargetRelation.COLUMNS.CHEMBL_ID

TargetRelation.COLUMNS_SETTINGS = {
  RESULTS_LIST_TABLE: [
    TargetRelation.COLUMNS.CHEMBL_ID
    TargetRelation.COLUMNS.RELATIONSHIP
    TargetRelation.COLUMNS.PREF_NAME
    TargetRelation.COLUMNS.TARGET_TYPE
  ]
}