// Generated by CoffeeScript 1.4.0
var SearchResultsApp;

SearchResultsApp = (function() {

  function SearchResultsApp() {}

  SearchResultsApp.initCompoundsResultsList = function() {
    var compsList;
    compsList = new CompoundResultsList;
    return compsList;
  };

  SearchResultsApp.initDocsResultsList = function() {
    var docsList;
    docsList = new DocumentResultsList;
    return docsList;
  };

  SearchResultsApp.initCompResultsListView = function(col, top_level_elem) {
    var compResView;
    compResView = new CompoundResultsListView({
      collection: col,
      el: top_level_elem
    });
    return compResView;
  };

  SearchResultsApp.initDocsResultsListView = function(col, top_level_elem) {
    var docResView;
    docResView = new DocumentResultsListView({
      collection: col,
      el: top_level_elem
    });
    return docResView;
  };

  SearchResultsApp.initCompTargMatrixView = function(topLevelElem) {
    var compTargMatrixView;
    compTargMatrixView = new CompoundTargetMatrixView({
      el: topLevelElem
    });
    return compTargMatrixView;
  };

  SearchResultsApp.initCompResultsGraphView = function(topLevelElem) {
    var compResGraphView;
    compResGraphView = new CompoundResultsGraphView({
      el: topLevelElem
    });
    return compResGraphView;
  };

  return SearchResultsApp;

})();
