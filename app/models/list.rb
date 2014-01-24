class List < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :category
  has_many :listings, :order => "position", :dependent => :destroy, :extend => AddPositionExtention
  has_many :items, :through => :listings
  accepts_nested_attributes_for :listings, :update_only => true, :allow_destroy => :true

  scope :pending_lists, -> { with_state(:pending) }
  scope :approved_lists, -> { with_state(:approved) }
  scope :rejected_lists, -> { with_state(:rejected) }

  has_reputation :list_points, source: :user, aggregated_by: :sum

  # Validations
  validates_presence_of :name
  validates_presence_of :category
  validates_uniqueness_of :name

  def points
    points = self.reputation_for(:list_points)
    points = self.calculate_points if points.eql?(0.0)
    points
  end

  def total_listings_votes
    listings.map { |l| l.reputation_for(:item_votes) }.inject{|sum,x| sum + x }
  end

  # methods for reordering listings position
  def reorder_listings_position
    listings = Listing.find_with_reputation(:item_votes, :all, { :conditions => ["list_id = ?", self.id], :order => 'item_votes DESC' })
    listings.each_with_index do |listing, index|
      listing.update_attribute(:position, index + 1)
    end
    self.listings
  end

  def calculate_points
    points = 0
    points += 5 unless self.description.nil?
    self.listings.each_with_index do |listing, index|
      if index <= 4
        points += 50
      elsif index > 4 and index <= 24
        points += 25
      end
      points += 10 unless listing.item.image.path.nil?
      unless listing.comments.empty?
        if comment = listing.comments.find_by_user_id(self.user.id)
          points += 5 unless comment.content.nil?
        end
      end
    end
    points
  end

  # User can create list with initial state pending
  # list will be reviewed first by the admin before displayed at the homepage
  # and if the list is approve the state will be change from pending to approved
  # and if the list is reject the state will be change from pending to rejected
  #
  # user are allow to edit and modify the rejected list
  # and they can submit again / reevaluate the list with state transition from rejected to pending
  #
  # sometimes the admin need to change / re-evaluate again the list
  # and allow to switch from approved state to rejected
  #
  # state_machine
  state_machine :initial => :pending do
    state :approved
    state :rejected

    event :approve do
      transition [:pending, :rejected] => :approved
    end

    event :reject do
      transition [:pending, :approved] => :rejected
    end

    event :evaluate do
      transition [:rejected, :approved] => :pending
    end

    after_transition :on => :approve do |list, transition|
      # generate list_points on list
      list.add_or_update_evaluation(:list_points, list.points, list.user)
      # here need to add the user points based on the list points
      list.user.add_or_update_evaluation(:points, list.points, list.user)
    end

    after_transition :on => [:reject, :evaluate] do |list, transition|
      # here need to reduce the user points based on the list points
      if list.evaluators_for(:list_points).include? list.user
        list.delete_evaluation(:list_points, list.user)
        list.user.add_or_update_evaluation(:points, -list.points, list.user)
      end
    end
  end

end
