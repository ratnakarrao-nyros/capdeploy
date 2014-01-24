require 'spec_helper'

describe Admins::ContactsController do

  before(:each) do
    request.env['HTTPS'] = 'on'
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
      contact = Fabricate(:contact)
      get :show, :id => contact.id
      response.should render_template(:show)
    end
  end

  describe "DELETE destroy" do
    it "should redirect to index template" do
      contact = Fabricate(:contact)
      delete :destroy, :id => contact.id
      response.should redirect_to(admins_contacts_path)
    end
  end
end
