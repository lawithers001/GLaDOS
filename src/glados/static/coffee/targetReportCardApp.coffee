class TargetReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->
    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    target = new Target
      target_chembl_id: GlobalVariables.CHEMBL_ID

    appDrugsClinCandsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
    appDrugsClinCandsList.initURL(GlobalVariables.CHEMBL_ID)

    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL GlobalVariables.CHEMBL_ID

    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()
    targetComponents.initURL GlobalVariables.CHEMBL_ID

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')

    new TargetComponentsView
      collection: targetComponents
      el: $('#TComponentsCard')

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    target.fetch()
    appDrugsClinCandsList.fetch()
    targetRelations.fetch({reset: true})
    targetComponents.fetch({reset: true})

  @initTargetNameAndClassification = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    target = new Target
      target_chembl_id: GlobalVariables.CHEMBL_ID

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')
    target.fetch()

  @initTargetComponents = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()
    targetComponents.initURL GlobalVariables.CHEMBL_ID

    new TargetComponentsView
      collection: targetComponents
      el: $('#TComponentsCard')

    targetComponents.fetch({reset: true})

  @initTargetRelations = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL GlobalVariables.CHEMBL_ID

    new RelationsView
      collection: targetRelations
      el: $('#TRelationsCard')

    targetRelations.fetch({reset: true})

  @initApprovedDrugsClinicalCandidates = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    appDrugsClinCandsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewApprovedDrugsClinicalCandidatesList()
    appDrugsClinCandsList.initURL(GlobalVariables.CHEMBL_ID)

    new ApprovedDrugsClinicalCandidatesView
      collection: appDrugsClinCandsList
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')

    appDrugsClinCandsList.fetch()

  @initMiniTargetReportCard = ($containerElem, chemblID) ->

    target = new Target({target_chembl_id: chemblID})
    new MiniReportCardView
      el: $containerElem
      model: target
      entity: Target
    target.fetch()

