// Generated by CoffeeScript 1.4.0
var DrugBrowserInfinityView;

DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend({
  initialize: function() {
    this.collection.on('sync', this.render, this);
    this.isInfinite = true;
    return this.containerID = 'DrugInfBrowserCardsContainer';
  },
  render: function() {
    var slider;
    console.log('num items in collection: ', this.collection.models.length);
    console.log('items: ', _.map(this.collection.models, function(item) {
      return item.get('molecule_chembl_id');
    }));
    if (this.collection.getMeta('current_page') === 1) {
      this.clearInfiniteContainer();
    }
    this.renderSortingSelector();
    this.showControls();
    $(this.el).find('select').material_select();
    this.fill_template(this.containerID);
    this.fillNumResults();
    this.hideInfiniteBrPreolader();
    this.setUpLoadingWaypoint();
    console.log('num cards: ', $('#DrugInfBrowserCardsContainer').children().length);
    slider = document.getElementById('search_max_phase');
    if ($(slider).attr('initialised') === 'yes') {
      return;
    }
    noUiSlider.create(slider, {
      start: [20, 80],
      connect: true,
      start: [0, 4],
      step: 1,
      range: {
        'min': 0,
        'max': 4
      },
      format: wNumb({
        decimals: 0
      })
    });
    slider.noUiSlider.on('set', this.setNumericSearchWrapper($(slider)));
    return $(slider).attr('initialised', 'yes');
  }
});
