// Generated by CoffeeScript 1.4.0
var ResponsiviseViewExt;

ResponsiviseViewExt = {
  updateView: function(debounced_render) {
    var $to_empty;
    if (this.$vis_elem != null) {
      $to_empty = this.$vis_elem;
    } else {
      $to_empty = $(this.el);
    }
    $to_empty.empty();
    this.showResponsiveViewPreloader();
    return debounced_render();
  },
  setUpResponsiveRender: function() {
    var debounced_render, reRender, updateViewProxy;
    reRender = function() {
      this.render();
      return this.hideResponsiveViewPreloader();
    };
    debounced_render = _.debounce($.proxy(reRender, this), 300);
    updateViewProxy = $.proxy(this.updateView, this, debounced_render);
    $(window).resize(function() {
      return updateViewProxy();
    });
    return updateViewProxy;
  },
  showResponsiveViewPreloader: function() {
    var $base_elem;
    if (this.$vis_elem != null) {
      $base_elem = this.$vis_elem;
    } else {
      $base_elem = $(this.el);
    }
    if ($base_elem.attr('data-loading') === 'false' || !($base_elem.attr('data-loading') != null)) {
      $base_elem.html(Handlebars.compile($('#Handlebars-Common-Preloader').html()));
      return $base_elem.attr('data-loading', 'true');
    }
  },
  hideResponsiveViewPreloader: function() {
    var $base_elem;
    if (this.$vis_elem != null) {
      $base_elem = this.$vis_elem;
    } else {
      $base_elem = $(this.el);
    }
    $base_elem.find('.card-preolader-to-hide').hide();
    return $base_elem.attr('data-loading', 'false');
  }
};
