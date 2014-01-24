class Admins::AdminsController < Admins::BaseController

  def index
    respond_to do |format|
      format.html
      format.json { render json: AdminsDatatable.new(view_context) }
    end
  end

  def show
    @admin = Admin.find(params[:id])
    authorize! :read, @admin
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params[:admin])
    authorize! :create, @admin
    if @admin.save
      redirect_to admins_admin_path(@admin), :notice => "Successfully created admin."
    else
      render :new
    end
  end

  def edit
    @field = params[:field] if params[:field]
    @admin = Admin.find(params[:id])
  end

  def update
    @field = params[:admin][:field] if params[:admin][:field]
    @admin = Admin.find(params[:id])
    authorize! :update, @admin
    params[:admin].delete(:field)
    if @admin.update_attributes(params[:admin])
      flash[:notice] = "Successfully updated admin."
      path = admins_admin_path(@admin)
      respond_to do |format|
        format.html { redirect_to path }
        format.js { render :js => "window.location = '#{path}'" }
      end
    else
      render :edit
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    authorize! :destroy, @admin
    @admin.destroy
    redirect_to admins_admins_url, :notice => "Successfully destroyed admin."
  end

end
