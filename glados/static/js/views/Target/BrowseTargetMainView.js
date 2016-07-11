// Generated by CoffeeScript 1.4.0
var BrowseTargetMainView;

BrowseTargetMainView = Backbone.View.extend({
  initialize: function() {
    this.model.on('change', this.setParentIds, this);
    this.listView = TargetBrowserApp.initBrowserAsList(this.model, $('#BCK-TargetBrowserAsList'));
    return this.circlesView = TargetBrowserApp.initBrowserAsCircles(this.model, $('#BCK-TargetBrowserAsCircles'));
  },
  setParentIds: function() {
    var lvl_1_nodes, node, setNodeParentId, _i, _len;
    lvl_1_nodes = this.model.get('children');
    setNodeParentId = function(node, parent_id) {
      var child, _i, _len, _ref, _results;
      node.parent_id = parent_id;
      if (node.children != null) {
        _ref = node.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child = _ref[_i];
          _results.push(setNodeParentId(child, node.id));
        }
        return _results;
      }
    };
    for (_i = 0, _len = lvl_1_nodes.length; _i < _len; _i++) {
      node = lvl_1_nodes[_i];
      setNodeParentId(node, void 0);
    }
    return console.log(this.model);
  }
});
