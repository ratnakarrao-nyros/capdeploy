class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
    authorize! :read, @item
  end
end
