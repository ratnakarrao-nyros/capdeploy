class Admins::ForumCategoriesController < Admins::BaseController

  def index
    respond_to do |format|
      format.html
      format.json { render json: ForumCategoriesDatatable.new(view_context) }
    end
  end

  def show
    @forum_category = ForumCategory.find(params[:id])
  end

  def new
    @forum_category = ForumCategory.new
  end

  def create
    @forum_category = ForumCategory.new(params[:forum_category])
    if @forum_category.save
      redirect_to admins_forum_category_path(@forum_category), :notice => "Forum Category was successfully created."
    else
      render :new
    end
  end

  def edit
    @forum_category = ForumCategory.find(params[:id])
  end

  def update
    @forum_category = ForumCategory.find(params[:id])
    if @forum_category.update_attributes(params[:forum_category])
      redirect_to admins_forum_category_path(@forum_category), :notice => "Forum Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @forum_category = ForumCategory.find(params[:id])
    @forum_category.destroy
    redirect_to admins_forum_categories_path, :notice => "Forum Category destroyed!"
  end

end
