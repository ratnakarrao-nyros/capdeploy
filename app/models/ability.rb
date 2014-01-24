class Ability
  include CanCan::Ability

  def initialize(resource)
    if resource.kind_of? Admin
      can :manage, :all
    else
      resource ||= User.new # guest user

      can :manage, User, :id => resource.id
      can :update, Profile, :user_id => resource.id

      # List object
      can :read, List, :state => "approved"
      can :update, List, :user_id => resource.id
      can :vote, List do |list|
        list.user.id != resource.id
      end
      # Comment object
      can :manage, Comment
      can [:update, :destroy], Comment, :user_id => resource.id
      cannot :vote, Comment do |comment|
        comment.user.id == resource.id
      end
      # Item object
      can :read, Item

      # this section actually comes from forum_monster
      can :read, ForumCategory, :state => true
      can :read, Forum, :state => true, :forum_category => { :state => true }
      can :read, Topic, :forum => { :state => true, :forum_category => { :state => true } }
      can :read, Post, :topic => { :forum => { :state => true, :forum_category => { :state => true } } }

      can :update, Post, :user_id => resource.id, :topic => { :locked => false }
      can :destroy, [Topic,Post], :user_id => resource.id, :topic => { :locked => false }

      can :create, Post, :topic => { :locked => false } unless resource.new_record?
      can :create, Topic unless resource.new_record?
      # end forum_monster
    end
  end
end
