// Generated by CoffeeScript 1.4.0
var MainPageApp;

MainPageApp = (function() {

  function MainPageApp() {}

  MainPageApp.init = function() {
    this.searchBarView = new SearchBarView();
    this.searchBarView.render();
    LazyIFramesHelper.initLazyIFrames();
    this.targetHierarchy = TargetBrowserApp.initTargetHierarchyTree();
    this.drugList = new DrugList({});
    this.targetBrowserView = TargetBrowserApp.initBrowserMain(this.targetHierarchy, $('#BCK-TargetBrowserMain'));
    this.drugBrowserTableView = DrugBrowserApp.initBrowserAsTable(this.drugList, $('#BCK-DrugBrowserMain'));
    this.drugList.fetch({
      reset: true
    });
    return LazyIFramesHelper.loadObjectOnceOnClick($('a[href="#browse_targets"]'), this.targetHierarchy);
  };

  return MainPageApp;

})();
