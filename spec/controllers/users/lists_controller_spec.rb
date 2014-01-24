require 'spec_helper'

describe Users::ListsController do

  before(:each) do
    login_user
  end

  describe "GET index" do
    it "should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "should render list with state is pending" do
      list = Fabricate(:list, user: @user)
      get :show, :id => list.id.to_s
      response.should_not be_success
    end

    it "should render list with state is rejected" do
      list = Fabricate(:list, user: @user)
      list.reject!
      get :show, :id => list.id.to_s
      response.should_not be_success
    end

    it "should render list with state is approved" do
      list = Fabricate(:list, user: @user)
      list.approve!
      get :show, :id => list.id.to_s
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
        List.any_instance.stub(:valid?).and_return(true)
        post :create, :list => Fabricate.attributes_for(:list, :user => @user)
        response.should redirect_to(users_list_path(assigns(:list)))
      end
    end

    describe "with invalid params" do
      it "should re-render new template" do
        List.any_instance.stub(:valid?).and_return(false)
        post :create, :list => nil
        response.should render_template(:new)
      end
    end
  end

  describe "GET edit" do
    it "should render edit template" do
      list = Fabricate(:list, user: @user)
      get :edit, :id => list.id.to_s
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to show template" do
        list = Fabricate(:list, user: @user)
        List.any_instance.stub(:valid?).and_return(true)
        put :update, :id => list.id.to_s, :list => Fabricate.attributes_for(:list)
        response.should redirect_to(users_list_path(assigns(:list)))
      end
    end

    describe "with invalid params" do
      it "should re-render edit template" do
        list = Fabricate(:list, user: @user)
        List.any_instance.stub(:valid?).and_return(false)
        put :update, :id => list.id.to_s, :list => {}
        response.should render_template(:edit)
      end
    end

    describe "with unauthorized user" do
      it "should not be able to update list" do
        list = Fabricate(:list)
        expect {
          put :update, :id => list.id.to_s, :list => Fabricate.attributes_for(:list)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
