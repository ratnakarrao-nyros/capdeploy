object @list
attributes :id, :user_id, :name, :description, :category_id, :state

child :listings => :listings_attributes do
  attributes :id, :list_id, :item_id, :position
  child :item => :item_attributes do
    attributes :id, :name, :description
    node :image do |i|
      i.image.nil? ? nil : i.image.url
    end
    node :total_shares do |i|
      i.recent_lists.select { |l| l.id != @list.id }.count
    end
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
  node :item_votes do |l|
    l.reputation_for(:item_votes)
  end
  node :total_comments do |l|
    l.comments.count
  end
  node :total_comments_votes do |l|
    l.total_comments_votes
  end
  node :latest_votes do |l|
    l.latest_votes.created_at unless l.latest_votes.nil?
  end
  node :latest_comment_votes do |l|
    l.latest_comment_votes.created_at unless l.latest_comment_votes.nil?
  end
end
