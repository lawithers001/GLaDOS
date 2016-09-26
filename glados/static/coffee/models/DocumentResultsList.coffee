DocumentResultsList = PaginatedCollection.extend

  model: Document

  parse: (data) ->

    data.page_meta.records_in_page = data.documents.length
    @resetMeta(data.page_meta)

    return data.documents

  initialize: ->

    @meta =
      server_side: true
      base_url: Settings.WS_DEV_BASE_URL + 'document.json'
      page_size: 6
      available_page_sizes: Settings.CARD_PAGE_SIZES
      current_page: 1
      to_show: []
      columns: [
        {
          'name_to_show': 'CHEMBL_ID'
          'comparator': 'document_chembl_id'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
          'link_base': '/document_report_card/$$$'
        }
        {
          'name_to_show': 'Title'
          'comparator': 'title'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
          'custom_field_template': '<i>{{val}}</i>'
        }
        {
          'name_to_show': 'Authors'
          'comparator': 'authors'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
        {
          'name_to_show': 'Year'
          'comparator': 'year'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
      ]

    @initialiseSSUrl()