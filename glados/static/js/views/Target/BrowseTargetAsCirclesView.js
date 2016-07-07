// Generated by CoffeeScript 1.4.0
var BrowseTargetAsCirclesView;

BrowseTargetAsCirclesView = Backbone.View.extend({
  initialize: function() {
    var debounced_render, updateViewProxy;
    this.showPreloader();
    console.log('setting resize event');
    debounced_render = _.debounce($.proxy(this.render, this), 300);
    updateViewProxy = $.proxy(this.updateView, this, debounced_render);
    return $(window).resize(function() {
      return updateViewProxy();
    });
  },
  showPreloader: function() {
    return $(this.el).html(Handlebars.compile($('#Handlebars-Common-Preloader').html()));
  },
  hidePreloader: function() {
    return $(this.el).find('.card-preolader-to-hide').hide();
  },
  updateView: function(debounced_render) {
    $(this.el).empty();
    this.showPreloader();
    return debounced_render();
  },
  render: function() {
    var color, diameter, elem_selector, margin, pack, svg;
    this.hidePreloader();
    margin = 20;
    diameter = 400;
    console.log('elem width is:');
    console.log($(this.el).width());
    color = d3.scale.linear().domain([-1, 5]).range(["#e0f2f1", "rgb(0, 110, 156)"]).interpolate(d3.interpolateRgb);
    pack = d3.layout.pack().padding(2).size([diameter - margin, diameter - margin]).value(function(d) {
      return d.size;
    });
    elem_selector = '#' + $(this.el).attr('id');
    svg = d3.select(elem_selector).append("svg").attr("width", diameter).attr("height", diameter).append("g").attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");
    return d3.json("static/data/flare.json", function(error, root) {
      var circle, focus, node, nodes, text, view, zoom, zoomTo;
      if (error) {
        console.log(error);
      }
      focus = root;
      nodes = pack.nodes(root);
      view = void 0;
      circle = svg.selectAll('circle').data(nodes).enter().append('circle').attr("class", function(d) {
        if (d.parent) {
          if (d.children) {
            return 'node';
          } else {
            return 'node node--leaf';
          }
        } else {
          return 'node node--root';
        }
      }).style("fill", function(d) {
        if (d.children) {
          return color(d.depth);
        } else {
          return null;
        }
      }).on("click", function(d) {
        if (focus !== d) {
          zoom(d);
          d3.event.stopPropagation();
        }
      });
      text = svg.selectAll('text').data(nodes).enter().append('text').attr("class", "label").style("fill-opacity", function(d) {
        if (d.parent === root) {
          return 1;
        } else {
          return 0;
        }
      }).style("display", function(d) {
        if (d.parent === root) {
          return 'inline';
        } else {
          return 'none';
        }
      }).text(function(d) {
        return d.name;
      });
      node = svg.selectAll("circle,text");
      d3.select(elem_selector).style("background", color(-1)).on("click", function() {
        return zoom(root);
      });
      zoomTo = function(v) {
        var k;
        k = diameter / v[2];
        view = v;
        node.attr("transform", function(d) {
          return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")";
        });
        return circle.attr("r", function(d) {
          return d.r * k;
        });
      };
      zoom = function(d) {
        var focus0, transition;
        focus0 = focus;
        focus = d;
        transition = d3.transition().duration(d3.event.altKey ? 7500 : 750).tween("zoom", function(d) {
          var i;
          i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin]);
          return function(t) {
            return zoomTo(i(t));
          };
        });
        return transition.selectAll("text").filter(function(d) {
          return d.parent === focus || this.style.display === 'inline';
        }).style('fill-opacity', function(d) {
          if (d.parent === focus) {
            return 1;
          } else {
            return 0;
          }
        }).each('start', function(d) {
          if (d.parent === focus) {
            this.style.display = 'inline';
          }
        }).each('end', function(d) {
          if (d.parent !== focus) {
            this.style.display = 'none';
          }
        });
      };
      zoomTo([root.x, root.y, root.r * 2 + margin]);
    });
  }
});
