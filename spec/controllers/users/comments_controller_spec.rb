require 'spec_helper'

describe Users::CommentsController do

  def generate_list_with_user(user=nil)
    user ||= Fabricate(:user)
    @list = Fabricate(:list, user: user)
    @listing = Fabricate(:listing, list: @list)
    @comment = Fabricate(:comment)
    @listing.comments << @comment
  end

  before(:each) do
    login_user
  end

  describe "GET index" do
    it "should render index template" do
      generate_list_with_user
      get :index, :list_id => @listing.list.id, :listing_id => @listing.id
      response.should render_template(:index)
    end
  end

  describe "authorized user" do
    before(:each) do
      generate_list_with_user
    end

    describe "POST create" do
      it "should create create if valid params" do
        post :create, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :comment => Fabricate.attributes_for(:comment)
        response.should be_success
        JSON.parse(response.body).should == JSON.parse(assigns(:comment).to_json)
      end

      it "should responds with JSON if errors" do
        post :create, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :comment => nil
        response.should_not be_success
        JSON.parse(response.body).count.should == 1
      end
    end

    describe "POST vote" do
      it "should vote the given comment with 1 if type 'up'" do
        post :vote, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :id => @comment.id, :type => "up"
        response.should be_success
        assigns(:comment).comment_votes.to_i.should == 1
        JSON.parse(response.body).should == JSON.parse(assigns(:comment).to_json)
      end

      it "should vote the given comment with -1 if type 'down'" do
        post :vote, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :id => @comment.id, :type => "down"
        response.should be_success
        assigns(:comment).comment_votes.to_i.should == -1
        JSON.parse(response.body).should == JSON.parse(assigns(:comment).to_json)
      end

      it "should responds with JSON if errors" do
        post :vote, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :id => 0, :type => "up"
        response.should_not be_success
        JSON.parse(response.body).count.should == 1
      end
    end
  end

  describe "unauthorized user" do
    before(:each) do
      generate_list_with_user(@user)
    end

    describe "POST create" do
      it "should create create if valid params" do
        post :create, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :comment => Fabricate.attributes_for(:comment)
        response.should_not be_success
        JSON.parse(response.body).count.should == 1
      end
    end

    describe "POST vote on user list" do
      it "should not be able to vote on user own list" do
        post :vote, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :id => @comment.id, :type => "up"
        response.should_not be_success
        JSON.parse(response.body).first.should eql("You cannot vote comments on your own list.")
      end
    end
  end

  describe "POST vote on user comment" do
    it "should not be able to vote on user own comment" do
      @list = Fabricate(:list)
      @listing = Fabricate(:listing, list: @list)
      @comment = Fabricate(:comment, user: @user)
      @listing.comments << @comment
      post :vote, :format => :json, :list_id => @listing.list.id, :listing_id => @listing.id, :id => @comment.id, :type => "down"
      response.should_not be_success
      JSON.parse(response.body).first.should eql("You cannot vote on your own comment.")
    end
  end

end
