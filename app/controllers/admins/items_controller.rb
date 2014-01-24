class Admins::ItemsController < Admins::BaseController

  def index
    respond_to do |format|
      format.html
      format.json { render json: ItemsDatatable.new(view_context) }
    end
  end

  def show
    @item = Item.find(params[:id])
    authorize! :read, @item
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    authorize! :create, @item
    if @item.save
      redirect_to admins_item_path(@item), :notice => "Item was successfully created."
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    authorize! :update, @item
    if @item.update_attributes(params[:item])
      redirect_to admins_item_path(@item), :notice => "Item was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    authorize! :destroy, @item
    @item.destroy
    redirect_to admins_items_path, :notice => "Item destroyed!"
  end

end
