class Users::CommentsController < Users::BaseController
  skip_before_filter :authenticate_user!, :only => [:index]
  respond_to :json, :except => [:index]

  # list all comments for given listing_id
  def index
    @list = List.find(params[:list_id])
    @listing = @list.listings.find(params[:listing_id])
    if params[:limit].present?
      idx = 0
      @listing.comments.select! do |c|
        idx = idx + 1
        idx <= params[:limit].to_i
      end
    end
    gon.current_user_id = current_user.id if current_user
    gon.rabl(:template => 'app/views/users/comments/index.json.rabl', :as => "list")
  end

  # this is create comment on the item
  def create
    if @list = List.find(params[:list_id])
      authorize! :vote, @list, :message => "You cannot add comments on your own list."
      if @listing = @list.listings.find(params[:listing_id])
        if @comment = current_user.add_comment_for(@listing, params[:comment])
          idx = 0
          @listing.comments.select! do |c|
            idx = idx + 1
            idx <= 3
          end
          render :json => Rabl::Renderer.new('users/comments/index', @list, :view_path => 'app/views', :locals => { :listing => @listing }).render
        else
          render :json => @comment.errors.to_a, :status => :unprocessable_entity
        end
      end
    end
  rescue => e
    render :json => [e.to_s], :status => :unprocessable_entity
  end

  # this is add vote on the comment
  def vote
    value = params[:type] == "up" ? 1 : -1
    @list = List.find(params[:list_id])
    authorize! :vote, @list, :message => "You cannot vote comments on your own list."
    @listing = @list.listings.find(params[:listing_id])
    @comment = @listing.comments.find(params[:id])
    authorize! :vote, @comment, :message => "You cannot vote on your own comment."

    if (@list and @listing and @comment) and @comment = current_user.vote_for(@comment, value)
      @comment[:user_full_name] = @comment.user.profile.full_name
      render :json => @comment
    else
      render :json => @comment.errors.to_a, :status => :unprocessable_entity
    end
  rescue => e
    render :json => [e.to_s], :status => :unprocessable_entity
  end

end
