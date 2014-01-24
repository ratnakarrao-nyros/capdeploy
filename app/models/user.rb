class User < ActiveRecord::Base
  include Gravtastic

  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable

  # Gravtastic
  has_gravatar

  has_reputation :points, source: :user, aggregated_by: :sum

  def points
    self.reputation_for(:points)
  end

  # Associations
  has_one :profile, :dependent => :destroy
  has_many :lists, :dependent => :destroy
  has_many :comments
  has_many :topics, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  accepts_nested_attributes_for :profile

  # Callbacks
  before_create do |user|
    user.build_profile if user.profile.nil?
  end

  after_update do |user|
    # only evaluate if user signing in different days
    if user.current_sign_in_at_changed?
      if (user.current_sign_in_at - user.last_sign_in_at) >= 1
        user.add_or_update_evaluation(:points, 100, user)
      end
    elsif user.current_sign_in_at.nil?
      # give user points for first time sign in
      user.add_or_update_evaluation(:points, 100, user)
    end
  end

  # this Class methods is needed for Authenticate using OmniAuth 1.0
  def self.find_or_create_by_omniauth(provider, request_env)
    # try to grep the email returned by request.env
    email = request_env.extra.raw_info.email if provider == :facebook
    # generate fake password
    password = Devise.friendly_token[0,20]
    attributes = { provider: request_env.provider, uid: request_env.uid, email: email, password: password, password_confirmation: password }
    user = self.where(provider: request_env.provider, uid: request_env.uid).first_or_initialize(attributes)
    user.skip_confirmation!
    user.save
    user
  end

  # Lists methods
  def my_lists
    self.lists
  end

  def my_favorite_lists
    List.joins(:listings => :evaluations).where("rs_evaluations.source_type = ? AND rs_evaluations.source_id = ?", self.class.to_s, self.id)
  end

  def my_pending_lists
    self.lists.where(:state => 'pending')
  end

  def my_approved_lists
    self.lists.where(:state => 'approved')
  end

  def my_rejected_lists
    self.lists.where(:state => 'rejected')
  end

  # Voting methods
  def voted_for?(obj)
    result = false
    if obj.kind_of? List
      result = self.voted_for_list?(obj)
    elsif obj.kind_of? Comment
      result = self.voted_for_comment?(obj)
    end
    result
  end

  def voted_for_list?(obj)
    result = true
    obj = List.find(obj) if obj.kind_of? Fixnum or obj.kind_of? String
    unless result = obj.user.eql?(self)
      obj.listings.each do |listing|
        if listing.evaluators_for(:item_votes).include? self
          result = true
          break
        end
      end
    end
    result
  end

  def voted_for_comment?(obj)
    result = false
    obj = Comment.find(obj) if obj.kind_of? Fixnum or obj.kind_of? String
    result = obj.evaluators_for(:comment_votes).include? self
    result
  end

  def vote_for(obj, value=1)
    if obj.kind_of? Listing # Vote for item list
      vote_for_listing(obj, value)
    elsif obj.kind_of? Comment # Vote for comment list
      vote_for_comment(obj, value)
    end
  end

  def vote_for_listing(listing, value=1)
    listing.add_evaluation(:item_votes, value, self)
    listing.list.touch
    self.add_or_update_evaluation(:points, 25, self)
    check_total_of_listings_votes(listing.list)
    listing.list.reorder_listings_position
    return Listing.find_with_reputation(:item_votes, listing.id)
  end

  def vote_for_comment(comment, value=1)
    comment.add_or_update_evaluation(:comment_votes, value, self)
    comment.commentable.reorder_comments_position
    comment.commentable.list.touch
    return Comment.find_with_reputation(:comment_votes, comment.id)
  end

  # Commenting methods
  def add_comment_for(parent, params)
    params.merge!(user_id: self.id) unless params[:user_id]
    comment = parent.comments.build(params)
    parent.save!
    parent.reorder_comments_position
    parent.list.touch
    self.add_or_update_evaluation(:points, 25, self)
    return Comment.find_with_reputation(:comment_votes, comment.id)
  end

  # Override activerecord-reputation-system
  def add_or_update_evaluation(reputation_name, value, source, *args)
    value = self.points.to_i + value
    super
  end

  def check_total_of_listings_votes(list)
    if list.total_listings_votes.to_i.modulo(1000) == 0
      if list.listings.count >= 5 and list.listings.count < 25
        list.user.add_or_update_evaluation(:points, 500, list.user)
      elsif list.listings.count >= 25
        list.user.add_or_update_evaluation(:points, 1000, list.user)
      end
    end
  end

end
