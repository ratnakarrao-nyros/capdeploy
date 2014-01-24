// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery-rest
//= require jquery-aw-showcase
//= require date/date
//= require bootstrap
//= require pnotify
//= require pnotify_loader
///////// require amazon_scroller
//= require jquery.bxslider2.min
//= require scripts.js
//= require jquery.cslider
//= require modernizr.custom.28468


$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  },
  statusCode: {
    401: function(e){
      //this will catch any and all access denied errors
      $.ajax({
        type : 'GET',
        url : '/users/sign_in',
        dataType : 'script',
        success: function(){
          var options = {
            text: e.responseText,
            sticker: false,
            history: false,
            type: 'error'
          };
          if(ajaxLoaderPnotify.loader_notify){
            ajaxLoaderPnotify.stop(options);
          }
          else {
            $.pnotify(options);
          }
        }
     });
    }
  }
});
