// Generated by CoffeeScript 1.4.0
var BrowseTargetAsListView;

BrowseTargetAsListView = Backbone.View.extend({
  initialize: function() {
    return this.model.on('change', this.render, this);
  },
  render: function() {
    var all_nodes, newView, new_elem, new_row, node, table, _i, _len, _ref;
    all_nodes = this.model.get('all_nodes');
    table = $(this.el).find('.tree');
    _ref = all_nodes.models;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      new_row = Handlebars.compile($('#Handlebars-TargetBrowser-AsList-item').html())({
        id: node.get('id'),
        name: node.get('name'),
        size: node.get('size'),
        parent_id: node.get('parent') != null ? node.get('parent').get('id') : void 0
      });
      new_elem = $(new_row);
      table.append(new_elem);
      newView = new BrowseTargetAsListNodeView({
        model: node,
        el: new_elem
      });
    }
    table.treegrid();
    return table.treegrid('collapseAll');
  },
  expandAll: function() {
    return $(this.el).find('.tree').treegrid('expandAll');
  },
  collapseAll: function() {
    return $(this.el).find('.tree').treegrid('collapseAll');
  }
});
