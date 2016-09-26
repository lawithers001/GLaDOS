// Generated by CoffeeScript 1.4.0
var RelationsView;

RelationsView = CardView.extend(PaginatedViewExt).extend({
  initialize: function() {
    this.collection.on('reset do-repaint sort', this.render, this);
    return this.resource_type = 'Target';
  },
  render: function() {
    if (this.collection.size() === 0 && !this.collection.getMeta('force_show')) {
      $('#TargetRelations').hide();
      return;
    }
    this.clearTable();
    this.clearList();
    this.fillTemplates('TRTable-large');
    this.fillTemplates('TR-UL-small');
    this.fillPaginators();
    this.showVisibleContent();
    this.initEmbedModal('relations');
    this.activateModals();
    this.fillPageSelectors();
    return this.activateSelectors();
  },
  clearTable: function() {
    return $('#TRTable-large').empty();
  },
  clearList: function() {
    return $('#TR-UL-small').empty();
  }
});
