// Generated by CoffeeScript 1.4.0
var PaginatedCollection;

PaginatedCollection = Backbone.Collection.extend({
  setMeta: function(attr, value) {
    if (_.isString(value)) {
      value = parseInt(value);
    }
    this.meta[attr] = value;
    return this.trigger('meta-changed');
  },
  getMeta: function(attr) {
    return this.meta[attr];
  },
  resetPageSize: function(new_page_size) {
    if (this.getMeta('server_side') === true) {
      return this.resetPageSizeSS(new_page_size);
    } else {
      return this.resetPageSizeC(new_page_size);
    }
  },
  resetMeta: function(page_meta) {
    if (this.getMeta('server_side') === true) {
      return this.resetMetaSS(page_meta);
    } else {
      return this.resetMetaC();
    }
  },
  calculateTotalPages: function() {
    var total_pages;
    total_pages = Math.ceil(this.models.length / this.getMeta('page_size'));
    return this.setMeta('total_pages', total_pages);
  },
  calculateHowManyInCurrentPage: function() {
    var current_page, page_size, total_pages, total_records;
    current_page = this.getMeta('current_page');
    total_pages = this.getMeta('total_pages');
    total_records = this.getMeta('total_records');
    page_size = this.getMeta('page_size');
    if (total_pages === 1) {
      return this.setMeta('records_in_page', total_records);
    } else if (current_page === total_pages) {
      return this.setMeta('records_in_page', total_records % page_size);
    } else {
      return this.setMeta('records_in_page', this.getMeta('page_size'));
    }
  },
  getCurrentPage: function() {
    if (this.getMeta('server_side') === true) {
      return this.getCurrentPageSS();
    } else {
      return this.getCurrentPageC();
    }
  },
  setPage: function(page_num) {
    if (page_num > this.getMeta('total_pages')) {
      return;
    }
    if (this.getMeta('server_side') === true) {
      return this.setPageSS(page_num);
    } else {
      return this.setPageC(page_num);
    }
  },
  sortCollection: function(comparator) {
    if (this.getMeta('server_side') === true) {
      return this.sortCollectionSS(comparator);
    } else {
      return this.sortCollectionC(comparator);
    }
  },
  resetSortData: function() {
    var col, columns, _i, _len, _results;
    this.comparator = void 0;
    columns = this.getMeta('columns');
    _results = [];
    for (_i = 0, _len = columns.length; _i < _len; _i++) {
      col = columns[_i];
      col.is_sorting = 0;
      _results.push(col.sort_class = 'fa-sort');
    }
    return _results;
  },
  setupColSorting: function(columns, comparator) {
    var col, is_descending, _i, _len;
    is_descending = false;
    for (_i = 0, _len = columns.length; _i < _len; _i++) {
      col = columns[_i];
      if (col.comparator === comparator) {
        col.is_sorting = (function() {
          switch (col.is_sorting) {
            case 0:
              return 1;
            default:
              return -col.is_sorting;
          }
        })();
        is_descending = col.is_sorting === -1;
      } else {
        col.is_sorting = 0;
      }
      col.sort_class = (function() {
        switch (col.is_sorting) {
          case -1:
            return 'fa-sort-desc';
          case 0:
            return 'fa-sort';
          case 1:
            return 'fa-sort-asc';
        }
      })();
    }
    return is_descending;
  },
  setSearch: function(term, column, type) {
    if (this.getMeta('server_side') === true) {
      return this.setSearchSS(term, column, type);
    } else {
      return this.setSearchC(term);
    }
  },
  getCurrentSortingComparator: function() {
    var columns, comp, sorVal;
    columns = this.getMeta('columns');
    sorVal = _.find(columns, function(col) {
      return col.is_sorting !== 0;
    });
    comp = void 0;
    if (!!(sorVal != null)) {
      comp = sorVal.comparator;
    }
    return comp;
  },
  resetSearchStruct: function() {
    var comparator, full_search_str, model, search_dict, _i, _j, _len, _len1, _ref, _ref1;
    if (!(this.getMeta('original_models') != null)) {
      this.setMeta('original_models', this.models);
      search_dict = {};
      _ref = this.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        model = _ref[_i];
        full_search_str = '';
        _ref1 = _.pluck(this.getMeta('columns'), 'comparator');
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          comparator = _ref1[_j];
          full_search_str += ' ' + model.get(comparator);
        }
        search_dict[full_search_str.toUpperCase()] = model;
      }
      return this.setMeta('search_dict', search_dict);
    }
  },
  resetMetaC: function() {
    this.setMeta('total_records', this.models.length);
    this.setMeta('current_page', 1);
    this.calculateTotalPages();
    this.calculateHowManyInCurrentPage();
    this.resetSortData();
    return this.resetSearchStruct();
  },
  getCurrentPageC: function() {
    var current_page, end, page_size, records_in_page, start, to_show;
    page_size = this.getMeta('page_size');
    current_page = this.getMeta('current_page');
    records_in_page = this.getMeta('records_in_page');
    start = (current_page - 1) * page_size;
    end = start + records_in_page;
    to_show = this.models.slice(start, +end + 1 || 9e9);
    this.setMeta('to_show', to_show);
    return to_show;
  },
  setPageC: function(page_num) {
    this.setMeta('current_page', page_num);
    return this.trigger('do-repaint');
  },
  resetPageSizeC: function(new_page_size) {
    if (new_page_size === '') {
      return;
    }
    this.setMeta('page_size', new_page_size);
    this.setMeta('current_page', 1);
    this.calculateTotalPages();
    this.calculateHowManyInCurrentPage();
    return this.trigger('do-repaint');
  },
  sortCollectionC: function(comparator) {
    var columns, is_descending;
    this.comparator = comparator;
    columns = this.getMeta('columns');
    is_descending = this.setupColSorting(columns, comparator);
    if (is_descending) {
      this.sort({
        silent: true
      });
      this.models = this.models.reverse();
      return this.trigger('sort');
    } else {
      return this.sort();
    }
  },
  setSearchC: function(term) {
    var answer, key, keys, model, new_models, original_models, search_dict, _i, _len;
    this.setMeta('force_show', true);
    term = term.toUpperCase();
    original_models = this.getMeta('original_models');
    search_dict = this.getMeta('search_dict');
    keys = Object.keys(search_dict);
    answer = [];
    for (_i = 0, _len = keys.length; _i < _len; _i++) {
      key = keys[_i];
      model = search_dict[key];
      model.set('show', key.indexOf(term) !== -1);
    }
    new_models = _.filter(original_models, function(item) {
      return item.get('show');
    });
    this.models = new_models;
    return this.reset(new_models);
  },
  resetMetaSS: function(page_meta) {
    this.setMeta('total_records', page_meta.total_count);
    this.setMeta('page_size', page_meta.limit);
    this.setMeta('current_page', (page_meta.offset / page_meta.limit) + 1);
    this.setMeta('total_pages', Math.ceil(page_meta.total_count / page_meta.limit));
    return this.setMeta('records_in_page', page_meta.records_in_page);
  },
  getCurrentPageSS: function() {
    return this.models;
  },
  setPageSS: function(page_num) {
    var base_url;
    base_url = this.getMeta('base_url');
    this.setMeta('current_page', page_num);
    this.url = this.getPaginatedURL();
    console.log('Getting page:');
    console.log(page_num);
    console.log('URL');
    console.log(this.url);
    return this.fetch();
  },
  getPaginatedURL: function() {
    var column, columns, comparator, field, full_url, info, limit_str, max, min, page_num, page_size, page_str, params, searchTerms, sorting, term, type, url, values, _i, _len;
    url = this.getMeta('base_url');
    page_num = this.getMeta('current_page');
    page_size = this.getMeta('page_size');
    params = [];
    limit_str = 'limit=' + page_size;
    page_str = 'offset=' + (page_num - 1) * page_size;
    params.push(limit_str);
    params.push(page_str);
    columns = this.getMeta('columns');
    sorting = _.filter(columns, function(col) {
      return col.is_sorting !== 0;
    });
    for (_i = 0, _len = sorting.length; _i < _len; _i++) {
      field = sorting[_i];
      comparator = field.comparator;
      if (field.is_sorting !== 1) {
        comparator = '-' + comparator;
      }
      params.push('order_by=' + comparator);
    }
    searchTerms = this.getMeta('search_terms');
    console.log('search terms:', searchTerms);
    for (column in searchTerms) {
      info = searchTerms[column];
      type = info[0];
      term = info[1];
      if (type === 'text') {
        if (term !== '') {
          params.push(column + "__contains=" + term);
        }
      } else if (type === 'numeric') {
        values = term.split(',');
        min = values[0];
        max = values[1];
        params.push(column + "__gte=" + min);
        params.push(column + "__lte=" + max);
      } else if (type === 'boolean') {
        if (term !== 'any') {
          params.push(column + "=" + term);
        }
      }
    }
    full_url = url + '?' + params.join('&');
    return full_url;
  },
  resetPageSizeSS: function(new_page_size) {
    if (new_page_size === '') {
      return;
    }
    this.setMeta('page_size', new_page_size);
    return this.setPage(1);
  },
  sortCollectionSS: function(comparator) {
    var columns;
    this.setMeta('current_page', 1);
    columns = this.getMeta('columns');
    this.setupColSorting(columns, comparator);
    this.url = this.getPaginatedURL();
    console.log('URL');
    console.log(this.url);
    return this.fetch();
  },
  setSearchSS: function(term, column, type) {
    var searchTerms;
    if (term === '') {
      return;
    }
    this.setMeta('current_page', 1);
    if (this.getMeta('search_terms') == null) {
      this.setMeta('search_terms', {});
    }
    searchTerms = this.getMeta('search_terms');
    searchTerms[column] = [type, term];
    this.url = this.getPaginatedURL();
    console.log('URL');
    console.log(this.url);
    return this.fetch();
  }
});
