// the viewModel for users/lists/show.html.erb
ko.bindingHandlers.bootstrapTooltip = {
    init: function(element, valueAccessor, allBindingsAccessor, viewModel) {
        var options = ko.utils.unwrapObservable(valueAccessor());
        var defaultOptions = {};
        options = $.extend(true, {}, defaultOptions, options);
        $(element).tooltip(options);
    }
};

function ListViewModel(list) {
  var self = this;
  // Load initial state from server, convert it to List instances, then populate listing items and comments
  self.list = ko.observable(new List(list));

  // Observable properties
  self.current_user_id = ko.observable(gon.current_user_id);
  self.user_already_voted = ko.observable(gon.user_already_voted);
  self.enableButton = ko.observable(true);
  self.newCommentList = ko.observable("");
  self.newCommentItem = ko.observable("");
  self.tempListingID = ko.observable(null);

  self.isEnableButton = ko.computed(function() {
    return self.enableButton() == true
  });

  self.errorCallback = function(response) {
    self.enableButton(true);
    var message = "An unknown error occurred. Support has been contacted.";
    if(response.status == 422){
      message = response.responseText;
    }
    ajaxLoaderPnotify.stop({ type: 'error', text: message});
  };


  self.loadComments = function(listing_id, data, event) {
    self.enableButton(false);
    ajaxLoaderPnotify.start();

    var commentsSize = 0;
    ko.utils.arrayFirst(self.list().listings_attributes(), function(listing) {
       if(listing.id() == listing_id) {
          commentsSize = listing.comments_attributes().length + 1;
       }
    });

    $.read(
      '/users/lists/{list_id}/listings/{listing_id}/comments',
      {
        list_id: gon.list.id,
        listing_id: listing_id,
        limit: commentsSize
      },
      function(list) {
        ko.utils.arrayFirst(self.list().listings_attributes(), function(listing) {
           if(listing.id() == listing_id) {
             listing.comments_attributes([]);
             listing.comments_attributes( $.map(list.listings_attributes[0].comments_attributes, function(comment) { return new Comment(comment) }) );
           }
        });
        self.enableButton(true);
        ajaxLoaderPnotify.stop({ display: false});
      },
      function(response) { self.errorCallback(response) }
    );
  };

  self.addCommentItem = function() {
    self.enableButton(false);
    ajaxLoaderPnotify.start();

    var newData = new Comment({
      id: null,
      content: self.newCommentItem(),
      user_id: self.current_user_id()
    });

    // parse list into JSON data
    var json_comment = JSON.parse(ko.toJSON(newData));

    $.create(
      '/users/lists/{list_id}/listings/{listing_id}/comments',
      {
        list_id: gon.list.id,
        listing_id: self.tempListingID(),
        comment: json_comment
      },
      function(list) {
        ko.utils.arrayFirst(self.list().listings_attributes(), function(listing) {
           if(listing.id() == self.tempListingID()) {
             listing.comments_attributes([]);
             listing.comments_attributes( $.map(list.listings_attributes[0].comments_attributes, function(comment) { return new Comment(comment) }) );
             listing.total_comments(list.listings_attributes[0].total_comments);
           }
        });
        self.newCommentList("");
        self.tempListingID(null);
        $('#modalItemComment').modal('hide');
        self.enableButton(true);
        ajaxLoaderPnotify.stop({ text: "Thank you for your comment."});
      },
      function(response) { self.errorCallback(response) }
    );
  };

  // Vote for item
  self.voteItem = function(listing) {
    self.enableButton(false);
    ajaxLoaderPnotify.start();

    $.create(
      '/users/lists/{list_id}/listings/{id}/vote',
      {
        list_id: gon.list.id,
        id: listing.id()
      },
      function(updatedListing) {
        var item_name;
        // update user_already_voted value to true
        self.user_already_voted(true);
        // store listing id into temp observable
        self.tempListingID(updatedListing.id);
        // find the listing id and store the latest item_votes value
        ko.utils.arrayFirst(self.list().listings_attributes(), function(listing) {
           if(listing.id() === updatedListing.id) {
             listing.item_votes(updatedListing.item_votes);
             item_name = listing.item_attributes().name();
           }
        });
        $('#modalItemComment').modal('show');
        self.enableButton(true);
        ajaxLoaderPnotify.stop({ text: "You vote for " + item_name + "!"});
      },
      function(response) { self.errorCallback(response) }
    );
  };

  // Vote for comment
  self.voteComment = function(listing_id, type, data, event) {
    self.enableButton(false);
    ajaxLoaderPnotify.start();

    $.create(
      '/users/lists/{list_id}/listings/{listing_id}/comments/{id}/vote',
      {
        list_id: gon.list.id,
        listing_id: listing_id,
        id: data.id(),
        type: type
      },
      function(updatedComment) {
        // update the lastest votes value
        var value;
        if(type == "up"){
          value = "+1";
        }
        else {
          value = "-1";
        }
        data.comment_votes(updatedComment.comment_votes);
        self.enableButton(true);
        ajaxLoaderPnotify.stop({ text: "You vote " + value + " for " + updatedComment.user_full_name + " comment!"});
      },
      function(response) { self.errorCallback(response) }
    );
  };

  // pagination
  self.filterArray = [ "Most voted items", "Most commented items", "Most voted comments", "Latest voted items", "Latest voted comments" ];
  self.selectedFilter = ko.observable("Most voted items");
  self.pageSizeArray = [10, 25, 50, 100];
  self.pageSize = ko.observable(10);
  self.pageIndex = ko.observable(0);

  self.maxPageIndex = ko.computed(function() {
    return Math.ceil(self.list().listings_attributes().length / self.pageSize()) - 1;
  });

  self.previousPage = function() {
    if (self.pageIndex() > 0) {
      self.pageIndex(self.pageIndex() - 1);
    }
  };

  self.nextPage = function() {
    if (self.pageIndex() < self.maxPageIndex()) {
      self.pageIndex(self.pageIndex() + 1);
    }
  };

  self.moveToPage = function(index) {
    self.pageIndex(index);
  };

  self.allPages = ko.computed(function() {
    var pages = [];
    for (i = 0; i <= self.maxPageIndex(); i++) {
      pages.push({ pageNumber: (i + 1) });
    }
    return pages;
  });

  // sorting items
  self.sortMostCommentedItems = function(a, b) {
    return a.total_comments() < b.total_comments() ? 1 : -1;
  };

  self.sortMostVotedComments = function(a, b) {
    return a.total_comments_votes() < b.total_comments_votes() ? 1 : -1;
  };

  self.sortLatestVotedItems = function(a, b) {
    if(a.latest_votes() == null) {
      return 1;
    }
    else if(b.latest_votes() == null) {
      return -1;
    }
    else {
      return Date.parse(b.latest_votes()).compareTo(Date.parse(a.latest_votes()));
    }
  };

  self.sortLatestVotedComments = function(a, b) {
    if(a.latest_comment_votes() == null) {
      return 1;
    }
    else if(b.latest_comment_votes() == null) {
      return -1;
    }
    else {
      return Date.parse(b.latest_comment_votes()).compareTo(Date.parse(a.latest_comment_votes()));
    }
  };

  self.pagedListings = ko.computed(function() {
    var size = self.pageSize();
    var start = self.pageIndex() * size;

    var filter = self.selectedFilter();

    switch (filter) {
      case "Most commented items":
        return self.list().listings_attributes.slice().sort(self.sortMostCommentedItems).slice(start, start + size);
        break;
      case "Most voted comments":
        return self.list().listings_attributes.slice().sort(self.sortMostVotedComments).slice(start, start + size);
        break;
      case "Latest voted items":
        return self.list().listings_attributes.slice().sort(self.sortLatestVotedItems).slice(start, start + size);
        break;
      case "Latest voted comments":
        return self.list().listings_attributes.slice().sort(self.sortLatestVotedComments).slice(start, start + size);
        break;
      default:
        // this will be the "Most voted items"
        return self.list().listings_attributes.slice(start, start + size);
        break;
    }
  });

  self.expandDetails = function(data,event) {
    var target;

    if (event.target) target = event.target;
    else if (event.srcElement) target = event.srcElement;

    if (target.nodeType == 3) // defeat Safari bug
      target = target.parentNode;

    var collapse = $(target).closest('.collapse-group').find('.collapse');
    collapse.collapse('toggle');

  };

  // global ajaxSuccess to retrieve and update current_user information
  $(document).ajaxSuccess(function(e, xhr, settings) {
    if ( settings.url == "/users/sign_in" && settings.type == "POST") {
        $.read(
          '/api/current_user_object',
          {
            current_user_id: 'id',
            user_already_voted: 'voted_for_list?,' + self.list().id()
          },
          function(data) {
            self.current_user_id(data.current_user_id);
            self.user_already_voted(data.user_already_voted);
          },
          function(response) { self.errorCallback(response) }
        );
    }
  });

}
