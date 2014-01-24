class Setting < ActiveRecord::Base
  store :preferences, accessors: [:top_scrolling_list]
  validates_presence_of :name, :preferences
end
