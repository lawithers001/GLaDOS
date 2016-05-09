// Generated by CoffeeScript 1.4.0
var ScrollSpyHelper;

ScrollSpyHelper = (function() {

  function ScrollSpyHelper() {}

  ScrollSpyHelper.initializeScrollSpyPinner = function() {
    var pinScrollSpy, scrollspy_wrapper, win;
    win = $(window);
    scrollspy_wrapper = $(".scrollspy-wrapper");
    pinScrollSpy = function() {
      var startFixation, top;
      startFixation = 122;
      top = win.scrollTop();
      if ((top > startFixation) && (scrollspy_wrapper.css('position') !== 'fixed')) {
        scrollspy_wrapper.removeClass('pin-top');
        return scrollspy_wrapper.addClass('pinned');
      } else if ((top < startFixation) && (scrollspy_wrapper.css('position') !== 'relative')) {
        scrollspy_wrapper.removeClass('pinned');
        return scrollspy_wrapper.addClass('pin-top');
      }
    };
    return win.scroll(_.throttle(pinScrollSpy, 200));
  };

  return ScrollSpyHelper;

})();
