require 'spec_helper'

describe ContactsController do

  describe "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "should redirect to show template" do
        post :create, :contact => Fabricate.attributes_for(:contact)
        response.should redirect_to(root_path)
      end
    end

    describe "with invalid params" do
      it "should re-render new template" do
        post :create, :contact => nil
        response.should render_template(:new)
      end
    end
  end
end
