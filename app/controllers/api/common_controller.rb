class Api::CommonController < ApplicationController
  before_filter :authenticate_user!, :only => [:current_user]
  respond_to :json

  # this is only upload image into cache directory
  def upload_image
    @uploader = ImageUploader.new
    if @uploader.cache!(params[:file])
      render json: { :image => @uploader.thumb.url }
    end
  rescue => e
    render :json => [e.to_s], :status => :unprocessable_entity
  end

  # this is used on the homepage section to filter list by category
  # ListType criteria
  def filter_by_category
    @category_lists = List.find(:all, :conditions => "state='approved' AND category_id=" + params[:category_id])
    @content = render_to_string('shared/_top_scrolling_list', :layout => false, :locals => { :lists => @category_lists })
    render :json => { :content => @content }
  end

  # Collect value or data from current_user object
  # and map it with JSON data
  #
  # For example to get current_user.id with the key name 'current_user_id' :
  #  { current_user_id: 'id' }
  # will return =>
  #  { current_user_id: 22 }
  #
  # if you like to pass an argument to the send method use ',' as a separator
  # For example to get current_user.voted_for_list?(16) with the key name 'user_already_voted' :
  #  { user_already_voted: 'voted_for_list?,16' }
  # will return =>
  #  { user_already_voted: true }
  #
  def current_user_object
    render :json => params.each { |key, value| params[key] = current_user.send(*value.split(",")) unless ["action", "controller"].include? key }
  end

end
