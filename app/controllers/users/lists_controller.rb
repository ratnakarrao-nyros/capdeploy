class Users::ListsController < Users::BaseController
  skip_before_filter :authenticate_user!, :only => [:index, :show]
  layout "simple_container", :only => [:new, :edit]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ListsDatatable.new(view_context) }
    end
  end

  def show
    @list = List.find(params[:id])
    authorize! :read, @list, :message => "Unable to find list [id: #{params[:id]}]"
    @list.listings.each do |listing|
      idx = 0
      listing.comments.select! do |c|
        idx = idx + 1
        idx <= 3
      end
    end
    setting_javascript_variables
  end

  def new
    @list = current_user.lists.build
    setting_javascript_variables
    respond_to do |format|
      format.html
      format.js { render :js => "window.location = '#{new_users_list_path}'" }
    end
  end

  def create
    @list = current_user.lists.build(params[:list])

    respond_to do |format|
      if @list.save
        format.html { redirect_to users_list_path(@list), :notice => "Successfully created list." }
        format.json { render :json => @list }
      else
        format.html { render :action => "new" }
        format.json { render :json => @list.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @list = current_user.lists.find(params[:id])
    # need to display owner comment at the first index
    # if empty then build initial comment
    @list.listings.each do |listing|
      listing.comments.select! { |c| c.user_id == current_user.id }
      if listing.comments.empty?
        listing.comments.build(user: current_user)
      end
    end
    setting_javascript_variables
  end

  def update
    @list = current_user.lists.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to users_list_path(@list), :notice => "List was successfully updated." }
        format.json { render :json => @list}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @list.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  private

  def setting_javascript_variables
    case params[:action]
    when "new"
      setting_form_variables do
        gon.is_new_list = true
        gon.path = '/users/lists'
      end
    when "edit"
      setting_form_variables do
        gon.is_new_list = false
        gon.path = '/users/lists/{id}'
      end
    when "show"
      gon.current_user_id = current_user.id if current_user
      gon.user_already_voted = (can? :vote, @list) ? ((current_user && current_user.voted_for?(@list)) ? true : false) : true
    end
    gon.rabl(:template => 'app/views/users/lists/show.json.rabl', :as => "list")
  end

  def setting_form_variables(&block)
    gon.categories = Category.all.map { |i| { "id" => i.id, "name" => i.name } }.unshift({ "id" => 0, "name" => "Select a Top5 Category" })
    gon.after_save_path = users_lists_path
    gon.upload_image_path = api_upload_image_path
    gon.flash_swf_url = ActionController::Base.helpers.asset_path("plupload/plupload.flash.swf")
    gon.authenticity_token = form_authenticity_token
    yield if block_given?
  end

end
