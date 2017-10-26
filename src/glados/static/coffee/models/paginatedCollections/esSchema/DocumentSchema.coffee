glados.useNameSpace 'glados.models.paginatedCollections.esSchema',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search Document Schema
  # --------------------------------------------------------------------------------------------------------------------
  DocumentSchema:
    FACETS_GROUPS: glados.models.paginatedCollections.esSchema.FacetingHandler.generateFacetsForIndex(
      'chembl_document'
      # Default Selected
      [
        'doc_type',
        'journal',
        # TODO 'src_id', does not exist yet
        'year',
      ],
      # Default Hidden
      [
      ],
      [

      ]
    )
