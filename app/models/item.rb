class Item < ActiveRecord::Base

  # Associations
  has_many :listings
  has_many :lists, :through => :listings

  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name

  mount_uploader :image, ImageUploader

  # override image setter
  def image=(obj)
    u = ImageUploader.new
    if obj =~ /#{u.cache_dir}/
      image_will_change!
      cache_name = File.dirname(obj).split("/").last + "/" + File.basename(obj).split("thumb_").last
      u.retrieve_from_cache! cache_name
      obj = File.open(Rails.root.to_s + "/public/" + u.to_s)
    end
    super(obj)
  end

  def recent_lists
    List.joins(:listings).where("listings.item_id = :item_id and lists.state = :state",item_id: self.id, state: "approved")
  end

end
