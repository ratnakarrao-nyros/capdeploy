class Admins::ListsController < Admins::BaseController
  respond_to :json, :only => [:approve, :reject]

  def index
    scope = params[:scope] || "all"
    scope.gsub!(/ /,'_')

    search = List.send(scope)
    unless params[:search] and params[:search].empty?
      unless search.respond_to? :where
        search = List
      end
      search = search.where("name iLike :search or description ilike :search", search: "%#{params[:search]}%")
    end
    @lists = search.paginate(:page => params[:page], :per_page => params[:per_page])

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @list = List.find(params[:id])
    authorize! :read, @list
  end

  def new
    @list = List.new
    setting_javascript_variables
  end

  def create
    @list = List.new(params[:list])
    authorize! :create, @list

    respond_to do |format|
      if @list.save
        format.html { redirect_to admins_list_path(@list), :notice => "Successfully created list." }
        format.json { render :json => @list}
      else
        format.html { render :action => "new" }
        format.json { render :json => @list.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @list = List.find(params[:id])
    setting_javascript_variables
  end

  def update
    @list = List.find(params[:id])
    authorize! :update, @list

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to admins_list_path(@list), :notice => "List was successfully updated." }
        format.json { render :json => @list}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @list.errors.to_a, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @list = List.find(params[:id])
    authorize! :destroy, @list
    @list.destroy
    redirect_to admins_lists_url, :notice => "Successfully destroyed list."
  end

  def approve
    @list = List.find(params[:id])

    if @list.approve!
      render :json => @list
    else
      render :json => ["Unable to approve list ID:#{@list.id}"], :status => :unprocessable_entity
    end
  end

  def reject
    @list = List.find(params[:id])

    if @list.reject!
      render :json => @list
    else
      render :json => ["Unable to approve list ID:#{@list.id}"], :status => :unprocessable_entity
    end
  end

private

  def setting_javascript_variables
    case params[:action]
    when "new"
      gon.is_new_list = true
      gon.path = '/admins/lists'
      setting_plupload_variables
    when "edit"
      gon.is_new_list = false
      gon.path = '/admins/lists/{id}'
      gon.pre_populate_user = [ { :id => @list.user.id, :email => @list.user.email } ]
      setting_plupload_variables
    end
    gon.after_save_path = admins_lists_path
    gon.rabl(:template => 'app/views/users/lists/show.json.rabl', :as => "list")
  end

  def setting_plupload_variables
    gon.categories = Category.all.map { |i| { "id" => i.id, "name" => i.name } }.unshift({ "id" => 0, "name" => "Select a Top5 Category" })
    gon.upload_image_path = api_upload_image_path
    gon.flash_swf_url = ActionController::Base.helpers.asset_path("plupload/plupload.flash.swf")
    gon.authenticity_token = form_authenticity_token
  end

end
