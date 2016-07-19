// Generated by CoffeeScript 1.4.0
var BrowseTargetAsCirclesNodeView;

BrowseTargetAsCirclesNodeView = Backbone.View.extend({
  initialize: function() {
    this.elem_selector = '#' + $(this.el).attr('id');
    return this.model.on('change', this.changed, this);
  },
  events: {
    'click': 'clicked'
  },
  changed: function() {
    return d3.select(this.elem_selector).classed('selected', this.model.get('selected') === true);
  },
  clicked: function() {
    return console.log('clicked ' + this.model.get('name'));
  }
});
