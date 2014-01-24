class Users::ListingsController < Users::BaseController
  respond_to :json

  # this is add vote on the item
  def vote
    @list = List.find(params[:list_id])
    authorize! :vote, @list, :message => "You cannot vote on your own list."
    @listing = @list.listings.find(params[:id])

    if (@list and @listing) and @listing = current_user.vote_for(@listing)
      render :json => @listing
    else
      render :json => @listing.errors.to_a, :status => :unprocessable_entity
    end
  rescue => e
    render :json => [e.to_s], :status => :unprocessable_entity
  end

end
