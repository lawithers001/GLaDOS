glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Compound Schema
  # --------------------------------------------------------------------------------------------------------------------
  CompoundSchema:
    FACETS_GROUPS:
      molecule_type:
        label: 'Molecule Type'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_type'
        )
      max_phase:
        label: 'Max Phase'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','max_phase'
        )
      full_mwt:
        label: 'Molecular Weight'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_properties.full_mwt'
        )
      hba:
        label: 'H.B.Acceptors'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_properties.hba'
        )
      hbd:
        label: 'H.B. Donors'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','molecule_properties.hbd'
        )
      related_targets_count:
        label: '# Related Targets'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','_metadata.related_targets.count'
        )
      activity_count:
        label: '# Bioactivities'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','_metadata.activity_count'
        )
      therapeutic_flag:
        label: 'Therapeutic'
        show: true
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','therapeutic_flag'
        )
      indication_class:
        label: 'Indication Class'
        show: false
        faceting_handler: glados.models.paginatedCollections.esSchema.FacetingHandler.getNewFacetingHandler(
          'chembl_molecule','indication_class'
        )
