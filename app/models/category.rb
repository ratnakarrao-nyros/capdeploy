class Category < ActiveRecord::Base
  # Associations
  has_many :lists

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name
end
