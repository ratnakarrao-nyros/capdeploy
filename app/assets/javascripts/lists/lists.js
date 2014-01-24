// This is the class object for represent List model

function List(data) {
  this.id = ko.observable(data.id);
  this.user_id = ko.observable(data.user_id);
  this.name = ko.observable(data.name);
  this.description = ko.observable(data.description);
  this.category_id = ko.observable(data.category_id);
  this.state = ko.observable(data.state);
  this.listings_attributes = ko.observableArray($.map(data.listings_attributes, function(listing) { return new Listing(listing) }));
}

function Listing(data) {
  this.id = ko.observable(data.id);
  this.list_id = ko.observable(data.list_id);
  this.item_id = ko.observable(data.item_id);
  this.position = ko.observable(data.position);
  this.item_votes = ko.observable(data.item_votes);
  this.total_comments = ko.observable(data.total_comments);
  this.total_comments_votes = ko.observable(data.total_comments_votes);
  this.latest_votes = ko.observable(data.latest_votes);
  this.latest_comment_votes = ko.observable(data.latest_comment_votes);
  this.item_attributes = ko.observable(new Item(data.item_attributes))
  this.comments_attributes = ko.observableArray($.map(data.comments_attributes, function(comment) { return new Comment(comment) }));
}

function Item(data) {
  this.id = ko.observable(data.id);
  this.name = ko.observable(data.name);
  this.description = ko.observable(data.description);
  this.image = ko.observable(data.image);
  this.total_shares = ko.observable(data.total_shares);
}

function Comment(data) {
  this.id = ko.observable(data.id);
  this.content = ko.observable(data.content);
  this.user_id = ko.observable(data.user_id);
  this.comment_votes = ko.observable(data.comment_votes);
  this.user_full_name = ko.observable(data.user_full_name);
}

// Customized how object List converted to JSON
// so it will remove unnecessary attributes
// while sending data back to the server
List.prototype.toJSON = function() {
  var obj = ko.toJS(this); //easy way to get a clean copy
  delete obj.state;
  return obj; //return the copy to be serialized
};

Listing.prototype.toJSON = function() {
  var obj = ko.toJS(this);
  delete obj.item_votes;
  delete obj.total_comments;
  delete obj.total_comments_votes;
  delete obj.latest_votes;
  delete obj.latest_comment_votes;
  return obj;
};

Item.prototype.toJSON = function() {
  var obj = ko.toJS(this);
  delete obj.total_shares;
  return obj;
};

Comment.prototype.toJSON = function() {
  var obj = ko.toJS(this);
  delete obj.comment_votes;
  delete obj.user_full_name;
  return obj;
};
