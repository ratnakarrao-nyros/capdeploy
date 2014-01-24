//need to hold the keys discretely, so they can be edited
function DictionaryItem(key, value) {
  this.key = ko.observable(key);
  this.value = ko.observable(value);
}

//represent the dictionary object
function SettingViewModel(data) {
  this.preferences = ko.observableArray([]);
  for (field in data) {
    if (data.hasOwnProperty(field)) {
      this.preferences.push(new DictionaryItem(field, data[field]));
    }
  }

  this.addPreference = function() {
    this.preferences.push(new DictionaryItem());
  }.bind(this);

  this.removePreference = function(preference) {
    this.preferences.remove(preference);
  }.bind(this);

  //when converting to JSON, put it back to the original format (not an array)
  this.toJSON = function() {
    var result = {};
    ko.utils.arrayForEach(this.preferences, function(preference) {
      result[preference.key] = preference.value;
    });
    return result;
  }
}

