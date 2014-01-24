function List(data) {
  this.id = ko.observable(data.id);
  this.name = ko.observable(data.name);
  this.description = ko.observable(data.description);
  this.state = ko.observable(data.state);
  this.posted_at = ko.observable(data.posted_at);
}

// the viewModel for users/lists/_form.html.erb
function ListModerationViewModel(options) {
  var self = this,
      url = options.url,
      scope = options.scope,
      sortBy = options.sortBy;

  // Give query params reasonable defaults, important for initial load
  self.lists = ko.observableArray([]);
  self.scope = ko.observable(scope);
  self.page = ko.observable(1);
  self.count = ko.observable(10);
  self.sortBy = ko.observable(sortBy);
  self.tableMessage = ko.observable("");
  self.isLoaded = ko.observable(false);
  self.filter = ko.observable("");
  self.totalRecordCount = ko.observable(0);
  // This registers a change only when filter stops changing for 250 ms
  self.throttledFilter = ko.computed(self.filter).extend({throttle: 250});

  // When filter changes go back to page 1
  self.throttledFilter.subscribe(function() {
    self.lists([]);
    self.page(1);
  });

  self.maxPage = function() {
    return Math.ceil(self.totalRecordCount() / self.count());
  };

  self.hasPreviousPage = ko.computed(function() {
    return self.page() > 1;
  });

  self.hasNextPage = ko.computed(function() {
    return self.page() < self.maxPage();
  });

  self.goToPreviousPage = function() {
    self.page(self.page() - 1);
  };

  self.goToNextPage = function() {
    self.page(self.page() + 1);
  };

  self.hasRecords = ko.computed(function() {
    return self.lists().length >= 1;
  });

  self.hasApproved = function(list) {
    return list.state() != "approved";
  };

  self.hasRejected = function(list) {
    return list.state() != "rejected";
  };

  self.displayNotification = function(options) {
     var _options = $.extend( {
        closer: true,
        sticker: false,
        hide: true,
        history: false
      }, options);
      $.pnotify(_options);
  };

  self.enableTableLoader = function(isDisplay, message){
    if(isDisplay){
      $('.progress').show();
      self.isLoaded(false);
      if(message){
        self.tableMessage(message);
      }
      else{
        self.tableMessage("Loading...");
      }
    }
    else{
      $('.progress').hide();
      self.isLoaded(true);
      if(message){
        self.tableMessage(message);
      }
      else{
        self.tableMessage("");
      }
    }
  }

  self.changeScope = function(scope) {
    return function(){
      self.lists([]);
      self.totalRecordCount(0);
      self.page(1);
      self.scope(scope);
      self.load();
    }
  };

  self.load = function() {
    self.enableTableLoader(true);
    $.read(
      url,
      {
        scope: self.scope(),
        page: self.page(),
        per_page: self.count(),
        sortBy: self.sortBy(),
        search: self.throttledFilter()
      },
      function(response) {
        if(response.length > 0){
          self.lists($.map(response, function(list) { return new List(list) }));
          self.totalRecordCount(response[0].total_lists_count);
          self.enableTableLoader(false);
        }
        else{
          if(self.scope() == "all"){
            self.enableTableLoader(false, "Currently there are no lists");
          }
          else {
            self.enableTableLoader(false, "Currently there are no " + self.scope());
          }
        }
      },
      function(response) {
        self.enableTableLoader(false, "There are some errors on the server.");
      }
    );
  };

  self.approve = function(list) {
    return function() {
      var url = '/admins/lists/' + list.id() + '/approve'
      $.update(
        url,
        function(response) {
          self.load();
          self.displayNotification({ type: 'info', text: 'List approved!' });
        },
        function(response) {
          self.displayNotification({ type: 'error', title: 'Got some errors!', text: response.statusText });
        }
      );
    }
  };

  self.reject = function(list) {
    return function() {
      var url = '/admins/lists/' + list.id() + '/reject'
      $.update(
        url,
        function(response) {
          self.load();
          self.displayNotification({ type: 'info', text: 'List rejected!' });
        },
        function(response) {
          self.displayNotification({ type: 'error', title: 'Got some errors!', text: response.statusText });
        }
      );
    }
  };


  // This will do initial load and loads after query params change
  ko.computed(self.load).extend({throttle: 1});

}
