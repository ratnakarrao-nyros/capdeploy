require 'spec_helper'

describe Admins::AdminsController do

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
      admin = Fabricate(:admin)
      get :show, :id => admin.id.to_s
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
        Admin.any_instance.stub(:valid?).and_return(true)
        post :create, :admin => Fabricate.attributes_for(:admin)
        response.should redirect_to(admins_admin_path(assigns(:admin)))
      end
    end

    describe "with invalid params" do
      it "should re-render new template" do
        Admin.any_instance.stub(:valid?).and_return(false)
        post :create, :admin => nil
        response.should render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "should render edit template" do
      admin = Fabricate(:admin)
      get :edit, :id => admin.id.to_s
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to show template" do
        admin = Fabricate(:admin)
        Admin.any_instance.stub(:valid?).and_return(true)
        put :update, :id => admin.id.to_s, :admin => Fabricate.attributes_for(:admin)
        response.should redirect_to(admins_admin_path(assigns(:admin)))
      end
    end

    describe "with invalid params" do
      it "should re-render edit template" do
        admin = Fabricate(:admin)
        Admin.any_instance.stub(:valid?).and_return(false)
        put :update, :id => admin.id.to_s, :admin => {}
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should redirect to index template" do
      admin = Fabricate(:admin)
      delete :destroy, :id => admin.id.to_s
      response.should redirect_to(admins_admins_path)
    end
  end
end
