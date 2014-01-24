require 'spec_helper'

describe Admins::ListsController do

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
      list = Fabricate(:list)
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
        post :create, :list => Fabricate.attributes_for(:list)
        response.should redirect_to(admins_list_path(assigns(:list)))
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
      list = Fabricate(:list)
      get :edit, :id => list.id.to_s
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to show template" do
        list = Fabricate(:list)
        List.any_instance.stub(:valid?).and_return(true)
        put :update, :id => list.id.to_s, :list => Fabricate.attributes_for(:list)
        response.should redirect_to(admins_list_path(assigns(:list)))
      end
    end

    describe "with invalid params" do
      it "should re-render edit template" do
        list = Fabricate(:list)
        List.any_instance.stub(:valid?).and_return(false)
        put :update, :id => list.id.to_s, :list => {}
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "should redirect to index template" do
      list = Fabricate(:list)
      delete :destroy, :id => list.id.to_s
      response.should redirect_to(admins_lists_path)
    end
  end

  describe "PUT approve" do
    it "should approve given list" do
      list = Fabricate(:list)
      put :approve, :id => list.id.to_s, :format => :json
      response.should be_success
      assigns(:list).state.should eql("approved")
      JSON.parse(response.body).should == JSON.parse(assigns(:list).to_json)
    end

    it "should responds with JSON if errors" do
      list = Fabricate(:list)
      List.any_instance.stub(:approve!).and_return(false)
      put :approve, :id => list.id.to_s, :format => :json
      response.should_not be_success
      JSON.parse(response.body).count.should == 1
    end
  end

  describe "PUT reject" do
    it "should reject given list" do
      list = Fabricate(:list)
      put :reject, :id => list.id.to_s, :format => :json
      response.should be_success
      assigns(:list).state.should eql("rejected")
      JSON.parse(response.body).should == JSON.parse(assigns(:list).to_json)
    end

    it "should responds with JSON if errors" do
      list = Fabricate(:list)
      List.any_instance.stub(:reject!).and_return(false)
      put :reject, :id => list.id.to_s, :format => :json
      response.should_not be_success
      JSON.parse(response.body).count.should == 1
    end
  end

end
