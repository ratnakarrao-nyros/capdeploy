require 'spec_helper'

describe Admins::DashboardController do

  before(:each) do
    login_admin
  end

  describe "GET index" do
    it "should render dashboard index" do
      get :index
      response.should be_success
    end
  end

end
