class Comment < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  # Validations
  validates_presence_of :user_id

  has_reputation :comment_votes, source: :user, aggregated_by: :sum
end
