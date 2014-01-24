require 'spec_helper'

describe Users::ListingsController do

  before(:each) do
    login_user
  end

  describe "POST vote" do
    it "should vote the given item" do
      listing = Fabricate(:listing)
      post :vote, :format => :json, :list_id => listing.list.id, :id => listing.id
      response.should be_success
      assigns(:listing).item_votes.to_i.should == 1
      JSON.parse(response.body).should == JSON.parse(assigns(:listing).to_json)
    end

    it "should responds with JSON if errors" do
      listing = Fabricate(:listing)
      post :vote, :format => :json, :list_id => listing.list.id, :id => 0
      response.should_not be_success
      JSON.parse(response.body).count.should == 1
    end
  end

end
