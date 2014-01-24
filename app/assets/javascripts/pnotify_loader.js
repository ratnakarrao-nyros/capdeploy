// the class to create ajaxLoader with pnotify.js

function AjaxLoaderPnotify() {
  var self = this;

  self.timerunning = 0;
  self.interval;
  self.loader_notify;

  // Public Methods
  // to start the ajaxLoaderPnotify
  self.start = function() {
      window.clearInterval(self.interval);
      self.loader_notify = null;
      self.timerunning = 0;
      self.interval = null;
      self.loader_notify = $.pnotify({
        title: "Please Wait",
        type: 'info',
        icon: 'picon picon-throbber',
        hide: false,
        closer: false,
        sticker: false,
        opacity: .75,
        shadow: false,
        width: "150px",
        history: false
      });

      self.loader_notify.pnotify({ title: false });

      self.interval = setInterval(function() {
          self.timerunning += 1;
          var options = {
              text: self.timerunning + " seconds."
          };
          self.loader_notify.pnotify(options);
      }, 120);

  };

  // to stop the ajaxLoaderPnotify
  self.stop = function(_options) {
     var options = {};

     try {
      if(_options.display != false) {
        options.type = _options.type || "success";
        if(options.type == "success") {
          options.title = "Done!";
          options.icon = 'picon picon-task-complete';
          options.hide = true;
        } else if(options.type == "error") {
          options.title = "Oh No!";
          options.icon = 'picon picon-emblem-important';
          options.hide = false;
        }

        if(_options.text != '') {
          try {
            var messages = [];
            messages = JSON.parse(_options.text);
            if($.isArray(messages)){
              var text = "<ul>";
              $.each(messages, function(index, value) {
                text = text + "<li>" + value + "</li>";
              });
              text = text + "</ul>";
              _options.text = text;
            }
          } catch(e) {
            options.text = _options.text;
          }
          options.text = _options.text;
        }

        options.closer = true;
        options.shadow = true;
        options.opacity = 1;
        options.width = $.pnotify.defaults.width;

        self.loader_notify.pnotify(options);
      }
      else {
        self.loader_notify.pnotify_remove();
      }

     } catch (e) {
       console.log(e);
     } finally {
        window.clearInterval(ajaxLoaderPnotify.interval);
        ajaxLoaderPnotify.timerunning = 0;
        ajaxLoaderPnotify.interval = null;
     }
  };
}

var ajaxLoaderPnotify = new AjaxLoaderPnotify();
