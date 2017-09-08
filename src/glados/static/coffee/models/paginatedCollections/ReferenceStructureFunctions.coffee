glados.useNameSpace 'glados.models.paginatedCollections',

  ReferenceStructureFunctions:

    initReferenceStructureFunctions: ->
      searchTerm = @getMeta('search_term')
      if searchTerm.startsWith('CHEMBL')
        @referenceCompound = new Compound
          id: searchTerm

        @referenceCompound.on 'change', @handleReferenceCompoundLoaded, @
        @referenceCompound.on 'error', @handleReferenceCompoundError, @
        @referenceCompound.fetch()
      else
        @setMeta('reference_smiles', searchTerm)

    handleReferenceCompoundLoaded: ->
      refSmiles = @referenceCompound.get('molecule_structures').canonical_smiles
      @setMeta('reference_smiles', refSmiles)
      @setMeta('reference_smiles_error', false)
      @setMeta('reference_smiles_error_jqxhr', undefined)

      for model in @models
        model.set('reference_smiles', refSmiles)
        model.set('reference_smiles_error', false)
        @setMeta('reference_smiles_error_jqxhr', undefined)

    handleReferenceCompoundError: (modelOrCollection, jqXHR) ->

      @setMeta('reference_smiles_error', true)
      @setMeta('reference_smiles_error_jqxhr', jqXHR)

      for model in @models
        model.set('reference_smiles_error', true)
        @setMeta('reference_smiles_error_jqxhr', jqXHR)

    toggleShowSimMaps: (active) ->

      active ?= not @getMeta(glados.PropertiesNames.Collections.SimilarityMaps.SHOW_SIMILARITY_MAPS)

      @setMeta(glados.PropertiesNames.Collections.SimilarityMaps.SHOW_SIMILARITY_MAPS, active)

      for model in @models
        model.set(glados.PropertiesNames.Compound.SimilarityMaps.SHOW_STRUCTURE, active)

