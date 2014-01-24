require 'spec_helper'

describe Admins::UsersController do

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
      user = Fabricate(:user)
      get :show, :id => user.id
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
        User.any_instance.stub(:valid?).and_return(true)
        post :create, :user => Fabricate.attributes_for(:user)
        response.should redirect_to(admins_user_path(assigns(:user)))
      end
    end

    describe "with invalid params" do
      it "should re-render new template" do
        User.any_instance.stub(:valid?).and_return(false)
        post :create, :user => nil
        response.should render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "should render edit template" do
      user = Fabricate(:user)
      get :edit, :id => user.id
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to show template" do
        user = Fabricate(:user)
        User.any_instance.stub(:valid?).and_return(true)
        put :update, :id => user.id, :user => Fabricate.attributes_for(:user)
        response.should redirect_to(admins_user_path(assigns(:user)))
      end
    end

    describe "with invalid params" do
      it "should re-render edit template" do
        user = Fabricate(:user)
        User.any_instance.stub(:valid?).and_return(false)
        put :update, :id => user.id, :user => nil
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should redirect to index template" do
      user = Fabricate(:user)
      delete :destroy, :id => user.id
      response.should redirect_to(admins_users_path)
      flash[:notice].should_not be_nil
    end
  end

end
