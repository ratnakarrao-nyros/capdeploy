// the viewModel for users/lists/_form.html.erb
function ListViewModel(list) {
  var self = this;

  // Load initial state from server, convert it to List instances, then populate listing items and comments
  self.list = ko.observable(new List(list));
  // Observable properties
  self.windowScrollTo = ko.observable(0);
  self.tempDestroyeditem = ko.observableArray([]);
  self.tempDestroyedcomment = ko.observableArray([]);
  self.availableCategories = ko.observableArray(gon.categories);
  self.searchItemQuery = ko.observable("");
  self.searchItemResults = ko.observableArray([]);
  self.isDisplayed = ko.observable(self.list().listings_attributes().length >= 5);

  // Subscriber functions
  self.searchItemQuery.subscribe(function (query) {
    if(query != ''){
     $('.items-list').addClass("loading")
     $.get(
       '/search_results/items',
       { term: query },
       function (data) {
         // this need to be slice to only 25 item with the most matches items
         items = $.grep(data, function (item) {
           if (item.name.toLowerCase().indexOf(self.searchItemQuery().trim().toLowerCase()) != -1) return item;
         })
         self.searchItemResults($.map(items.slice(0, 25), function(item) { return new Item(item) }));
         $(".icon-info-sign").tooltip();
         $('.items-list').removeClass("loading")
       }
     );
    } else {
      self.searchItemResults.removeAll();
    }
  });

  // need to store position number whenever the sortable lists is changing
  self.list().listings_attributes.subscribe(function () {
    $.each(self.list().listings_attributes(), function (index, listing) {
      listing.position = index + 1;
    });
  });

  // Sortable operation functions
  // verify that if item is already added to the listing or not
  self.verifyItem = function(arg) {
    if(arg.sourceParent === undefined){
      if(self.list().listings_attributes().length > 0) {
        ko.utils.arrayFirst(self.list().listings_attributes(), function(listing) {
          if(listing.item_id() === arg.item.item_id()) {
            self.displayNotification({ type: 'error', title: 'Got some errors!', text: 'You already have <strong>' + arg.item.item_attributes().name() + '</strong> on the list.' });
            arg.cancelDrop = true;
          }
        });
      }
    }
  };

  // Add New Item
  self.addItem = function(item) {
    return new Listing({
      id: null,
      list_id: null,
      item_id: item.id(),
      position: self.list().listings_attributes().length + 1,
      item_attributes: {
        id: item.id(),
        name: item.name(),
        image: item.image()
      },
      comments_attributes: [{
        id: null,
        content: null,
        user_id: self.list().user_id()
      }]
    });
  };

  // Add New Item
  self.addNewItem = function() {
   var newData = new Listing({
      id: null,
      list_id: null,
      item_id: null,
      position: self.list().listings_attributes().length + 1,
      item_attributes: {
        id: null,
        name: null,
        image: null
      },
      comments_attributes: [{
        id: null,
        content: null,
        user_id: self.list().user_id()
      }]
    });
    self.list().listings_attributes.push(newData);
  };

  // callback after adding item to listings_attributes
  self.addCallback = function(ui,e,arg) {
    $(".btn-mini").not("[data-toggle=popover]").tooltip();
    $(".thumbnail").tooltip();
    $(ui).effect("highlight", { color: '#fcf8e3' }, "slow");
    if(self.list().listings_attributes().length == 5 && self.isDisplayed() == false) {
      self.displayNotification({ title: 'Congratulations!', text: 'You have added 5 items. Now you can save your list or continue to add more!' });
      self.isDisplayed(true);
    }
  };

  // Remove Item
  self.removeItem = function(item) {
    if(item.id() != null) {
      self.list().listings_attributes.destroy(item)
      item.position = 0; // mark with zero
      self.tempDestroyeditem.push(item);
    }
    // mark notification for less than 5 items
    self.list().listings_attributes.remove(item)
    if(self.list().listings_attributes().length == 4 && self.isDisplayed() == true) {
      self.isDisplayed(false);
    }
  };

  // Remove Comment
  self.removeComment = function(listing, data, event) {
    if(data.id() != null) {
      listing.comments_attributes.destroy(data);
      self.tempDestroyedcomment.push(data);
    }
  };

  // click to upload image
  self.editImageItem = function(data, event) {
    // create plupload uploader
    var uploader = new plupload.Uploader({
      runtimes : 'html5,flash,browserplus',
      max_file_size : '10mb',
      url : gon.upload_image_path,
      flash_swf_url : gon.flash_swf_url,
      multi_selection: false,
      filters : [
        {title : "Image files", extensions : "jpg,gif,png"}
      ],
      multipart: true,
      multipart_params: { authenticity_token : gon.authenticity_token }
    });

    // initialize
    uploader.init();

    // open file input dialog
    var input = $('#' + uploader.id + '_html5');
    // for some reason FF (up to 8.0.1 so far) lets to click disabled input[type=file]
    if (input && !input.disabled) {
        input.click();
    }

    //uploader callbacks
    uploader.bind('FilesAdded', function(up, files) {
      if(up.state!=2 & files.length>0){
        ajaxLoaderPnotify.start();
        up.refresh();
        up.start();
      }
    });

    uploader.bind('Error', function(up, err) {
      up.refresh(); // Reposition Flash/Silverlight
      $("html, body").animate({ scrollTop: self.windowScrollTo() }, "slow");
      ajaxLoaderPnotify.stop({ type: 'error', text: response.responseText});
    });

    uploader.bind('FileUploaded', function(up, file, response) {
      try{
        var obj = jQuery.parseJSON(response.response);
        data.item_attributes().image(obj.image);
        ajaxLoaderPnotify.stop({text: file.name + " uploaded"});
      }
      catch(e){
        ajaxLoaderPnotify.stop({ type: 'error', text: 'Internal Server Error'});
      }
    });

    $('.thumbnail').tooltip('hide')
  };

  // Save
  self.save = function() {
    if(self.validateList()){
      $("#myButton").attr('disabled',true);
      ajaxLoaderPnotify.start();
      // merge destroyed items before save
      if(self.tempDestroyeditem().length != 0) {
        ko.utils.arrayForEach(self.tempDestroyeditem(), function(item) {
          self.list().listings_attributes.push(item);
        });
      }

      // parse list into JSON data
      var json_list = JSON.parse(ko.toJSON(self.list));

      if(gon.is_new_list) {
        $.create(
          gon.path,
          { list: json_list },
          function(response) { self.successCallback(response); },
          function(response) { self.errorCallback(response); }
        );
      } else {
        $.update(
          gon.path,
          { id: self.list().id(), list: json_list },
          function(response) { self.successCallback(response); },
          function(response) { self.errorCallback(response); }
        );
      }
    }
  };

  // callbacks
  self.successCallback = function(createdList) {
    $("#myButton").removeAttr('disabled');
    ajaxLoaderPnotify.stop({ text: "Successfully created list."});
    window.location = gon.after_save_path;
  };

  self.errorCallback = function(response) {
    $("#myButton").removeAttr('disabled');

    // Use the specific message for a 500, but
    // a generic failure message for others
    var message = (response.status == 422) ? response.responseText : "An unknown error occurred. Support has been contacted.";

    // switch back all the items if some errors occurs
    var differences = ko.utils.compareArrays(self.list().listings_attributes, self.tempDestroyeditem());
    ko.utils.arrayForEach(differences, function(difference) {
      if (difference.status === "added") {
        self.list().listings_attributes.remove(difference.value);
      }
    });
    $("html, body").animate({ scrollTop: self.windowScrollTo() }, "slow");
    self.windowScrollTo(0);
    ajaxLoaderPnotify.stop({ type: 'error', text: message});
  };

  // Other function
  // boolean to check number of listings
  self.isListingsLessThanFive = ko.computed(function() {
    if( self.list().listings_attributes().length < 5 ) {
     return true;
    } else {
      return false;
    }
  });

  self.estimatedPoints = ko.computed(function() {
    var points = 0;
    // additional points for list description
    if(self.list().description() != null && self.list().description() != ''){ points += 5; }
    $.each(self.list().listings_attributes(), function (index, listing) {
      if(index <= 4){
        points += 50;
      }
      else if(index > 4 && index <= 24) {
        points += 25;
      }
      // additional points for item image and comment
      if(listing.item_attributes().image() != null && listing.item_attributes().image() != ''){ points += 10; }
      if(listing.comments_attributes().length > 0) {
        if(listing.comments_attributes()[0].content() != null && listing.comments_attributes()[0].content() != ''){ points += 5; }
      }
    });
    return points;
  });

  self.levelOfCompleteness = ko.computed(function() {
    var percentage = 0,
        count = 3;
    if(self.list().name() != null && self.list().name() != ''){ percentage += 1; }
    if(self.list().description() != null && self.list().description() != ''){ percentage += 1; }
    if(self.list().category_id() != null && self.list().category_id() != ''){ percentage += 1; }
    $.each(self.list().listings_attributes(), function (index, item) {
      count += 4;
      percentage += 1;
      if(item.item_attributes().name() != null && item.item_attributes().name() != ''){ percentage += 1; }
      if(item.item_attributes().image() != null && item.item_attributes().image() != ''){ percentage += 1; }
      if(item.comments_attributes().length > 0) {
        if(item.comments_attributes()[0].content() != null && item.comments_attributes()[0].content() != ''){ percentage += 1; }
      }
    });
    if(self.list().listings_attributes().length < 5){
      count += (5 - self.list().listings_attributes().length) * 4;
    }
    percentage = (percentage / count) * 100
    // need to set bar with different color
    $('.bar')[0].className = 'bar';
    if(percentage <= 40){
      $('.bar').addClass("bar-danger");
    }
    else if(percentage < 70){
      $('.bar').addClass("bar-warning");
    }
    return percentage.toFixed(0).toString() + '%';
  });

  self.itemBackgroundColor = function(item, index) {
    var incomplete = 0,
        color = '#f0f0f0';

    if(item.item_attributes().name() == null || item.item_attributes().name() == ''){ incomplete++; }
    if(item.item_attributes().image() == null){ incomplete++; }
    if(item.comments_attributes().length > 0) {
      if(item.comments_attributes()[0].content() == null || item.comments_attributes()[0].content() == ''){ incomplete++; }
    }
    else {
      incomplete++;
    }

    switch(incomplete) {
      case 1:
        color = '#e0e0e0';
        break;
      case 2:
        color = '#d3d3d3';
        break;
      case 3:
        color = '#c0c0c0';
        break;
      default:
        $('#item_' + index).css('background-color', '#f0f0f0');
        $('#item_' + index).effect("highlight", { color: '#dff0d8' }, "slow");
    }
    return color;
  };

  self.initializeTooltip = function() {
    $(".btn-mini").not("[data-toggle=popover]").tooltip();
    $(".thumbnail").tooltip();
    $(".close").popover();
    $(".progress").tooltip();
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

  self.validateList = function() {
    var result = true;
    if(self.list().listings_attributes().length < 5){
      self.displayNotification({ type: 'error', title: 'Got some errors!', text: 'Holy guacamole! You only add ' + self.list().listings_attributes().length.toString() + ' items on the list, you need to add a minimum of 5 items to your list.' });
      result = false;
    }
    $.each($('#list_name').add($('#list_category_id')).add($('.item_name')).get().reverse(), function() {
       // initialize validation
       $(this).jqBootstrapValidation({
           preventSubmit: true,
           filter: function() {
               return $(this).is(":visible");
           }
       });
       if($(this).jqBootstrapValidation("hasErrors")){
         $(this).trigger("change.validation", {submitting: true});
         // set windowScrollTo
         self.windowScrollTo($(this).offset().top - 100);
       }
    });
    return result;
  };

}
