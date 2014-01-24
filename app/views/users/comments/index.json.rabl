object @list
attributes :id, :user_id, :name, :description, :category_id

child [ @listing ] => :listings_attributes do
  attributes :id, :list_id, :item_id, :position
  child :item => :item_attributes do
    attributes :id, :name, :description
  end
  child :comments => :comments_attributes do
    attributes :id, :content, :user_id
    node :comment_votes do |c|
      c.reputation_for(:comment_votes)
    end
    node :user_full_name do |c|
      c.user.profile.full_name
    end
  end
  node :total_comments do |l|
    l.comments.count
  end
end
