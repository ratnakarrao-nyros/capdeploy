class Profile < ActiveRecord::Base

  belongs_to :user

  mount_uploader :avatar, ImageUploader

  def full_name
    first_name + " " + last_name if first_name and last_name
  end
end
