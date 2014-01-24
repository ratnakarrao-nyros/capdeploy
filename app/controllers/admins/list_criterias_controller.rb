class Admins::ListCriteriasController < Admins::BaseController

  def index
    search = ListCriteria.where('name ilike ?', "%#{params[:search]}%")
    search = search.order(params[:sort] + " " + params[:direction]) unless params[:sort].blank? && params[:direction].blank?

    @list_criterias = search.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def show
    @list_criteria = ListCriteria.find(params[:id])
    authorize! :read, @list_criteria
  end

  def new
    @list_criteria = ListCriteria.new
  end

  def create
    @list_criteria = ListCriteria.new(params[:list_criteria])
    authorize! :create, @list_criteria
    if @list_criteria.save
      redirect_to admins_list_criteria_path(@list_criteria), :notice => "ListCriteria was successfully created."
    else
      render :new
    end
  end

  def edit
    @list_criteria = ListCriteria.find(params[:id])
  end

  def update
    @list_criteria = ListCriteria.find(params[:id])
    authorize! :update, @list_criteria
    if @list_criteria.update_attributes(params[:list_criteria])
      redirect_to admins_list_criteria_path(@list_criteria), :notice => "ListCriteria was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @list_criteria = ListCriteria.find(params[:id])
    authorize! :destroy, @list_criteria
    @list_criteria.destroy
    redirect_to admins_list_criterias_path, :notice => "ListCriteria destroyed!"
  end

end
