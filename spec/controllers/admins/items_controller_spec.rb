require 'spec_helper'

describe Admins::ItemsController do

  before(:each) do
    login_admin
  end

  describe "GET index" do
    it "should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "should render show template" do
      item = Fabricate(:item)
      get :show, :id => item.id
      response.should render_template(:show)
    end
  end

  describe "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "should redirect to show template" do
        Item.any_instance.stub(:valid?).and_return(true)
        post :create, :item => Fabricate.attributes_for(:item)
        response.should redirect_to(admins_item_path(assigns(:item)))
      end
    end

    describe "with invalid params" do
      it "should re-render new template" do
        Item.any_instance.stub(:valid?).and_return(false)
        post :create, :item => nil
        response.should render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "should render edit template" do
      item = Fabricate(:item)
      get :edit, :id => item.id
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to show template" do
        item = Fabricate(:item)
        Item.any_instance.stub(:valid?).and_return(true)
        put :update, :id => item.id, :item => Fabricate.attributes_for(:item)
        response.should redirect_to(admins_item_path(assigns(:item)))
      end
    end

    describe "with invalid params" do
      it "should re-render edit template" do
        item = Fabricate(:item)
        Item.any_instance.stub(:valid?).and_return(false)
        put :update, :id => item.id, :item => nil
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should redirect to index template" do
      item = Fabricate(:item)
      delete :destroy, :id => item.id
      response.should redirect_to(admins_items_path)
      flash[:notice].should_not be_nil
    end
  end

end
