class Listing < ActiveRecord::Base
  # Associations
  belongs_to :list
  belongs_to :item
  has_many :comments, :as => :commentable, :order => "position", :dependent => :destroy, :extend => AddPositionExtention
  has_many :evaluations, :class_name => "RSEvaluation", :as => :source
  accepts_nested_attributes_for :comments, :update_only => true, :reject_if => proc { |attr| Listing.check_comment_for_removal(attr) }, :allow_destroy => true
  accepts_nested_attributes_for :item, :update_only => true

  after_save do |listing|
    listing.reorder_comments_position
  end

  # Validations
  validates_uniqueness_of :item_id, :scope => :list_id

  has_reputation :item_votes, source: :user, aggregated_by: :sum

  def total_comments_votes
   comments.map { |c| c.reputation_for(:comment_votes) }.inject{|sum,x| sum + x }
  end

  def latest_votes
    unless self.evaluations.empty?
      self.evaluations.order("created_at DESC").first
    end
  end

  def latest_comment_votes
    ReputationSystem::Evaluation.joins("INNER JOIN comments ON rs_evaluations.target_id = comments.id INNER JOIN listings ON comments.commentable_id = listings.id")
    .where("rs_evaluations.target_type = 'Comment' AND rs_evaluations.reputation_name = 'comment_votes' AND comments.commentable_type = 'Listing' AND listings.id = ?", self.id)
    .order("rs_evaluations.created_at DESC").first
  end

  # methods for reordering commments position
  def reorder_comments_position
    comments = Comment.find_with_reputation(:comment_votes, :all, { :conditions => ["commentable_type = ? AND commentable_id = ?", self.class.name, self.id], :order => 'comment_votes DESC' })
    comments.each_with_index do |comment, index|
      comment.update_attribute(:position, index + 1)
    end
    self.comments
  end

  def self.check_comment_for_removal(attr)
    flag = attr[:content].blank?
    if attr[:content].blank? and !attr[:id].blank?
      attr[:_destroy] = true
      flag = false
    end
    flag
  end

end
