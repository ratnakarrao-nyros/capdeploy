require 'spec_helper'

describe User do

  it "should have fields" do
    ## Database authenticatable
    should have_attribute(:email)
    should have_attribute(:encrypted_password)

    ## Recoverable
    should have_attribute(:reset_password_token)
    should have_attribute(:reset_password_sent_at)

    ## Rememberable
    should have_attribute(:remember_created_at)

    ## Trackable
    should have_attribute(:sign_in_count)
    should have_attribute(:current_sign_in_at)
    should have_attribute(:last_sign_in_at)
    should have_attribute(:current_sign_in_ip)
    should have_attribute(:last_sign_in_ip)

    ## Confirmable
    should have_attribute(:confirmation_token)
    should have_attribute(:confirmed_at)
    should have_attribute(:confirmation_sent_at)
    should have_attribute(:unconfirmed_email)
  end

  it "should validate precence of" do
    should validate_presence_of :email
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:email)
  end

  it "should have one profile" do
    should have_one(:profile).dependent(:destroy)
  end

  it "should have many lists & comments" do
    should have_many(:lists).dependent(:destroy)
    should have_many(:comments)
  end

  describe "scoring systems" do

    describe "Voting, Commenting and Add Listing" do
      before(:each) do
        @user = Fabricate(:user)
        @listing = Fabricate(:listing)
      end

      # Voting on a list (25 points)
      it "should have 25 points if user voting some listing on the list" do
        @user.vote_for(@listing)
        @user.points.should eql(25.0)
      end

      # Commenting on the listing of the list (25 points)
      it "should have 25 points if user commenting on the listing of the list" do
        @user.add_comment_for(@listing, Fabricate.attributes_for(:comment, user: @user))
        @user.points.should eql(25.0)
      end
    end

    describe "Create approved list" do
      before(:each) do
        @list = Fabricate(:list, description: nil)
        @user = @list.user
      end

      def create_listing_listings(num)
        num.times do
            Fabricate(:listing, list: @list)
        end
        @list.approve!
      end

      def give_votes_on_listings(votes_value=200)
        # for this example assume that every user vote is 200 points for 5 listings and 40 for 25 listings
        @list.listings.each do |listing|
          user = Fabricate(:user)
          user.vote_for(listing, votes_value)
        end
      end

      describe "with 5 listings" do
        before(:each) do
          create_listing_listings(5)
        end

        # Creating a list with at least 5 choices (250 points)
        it "should have 250 points"do
          @user.points.should eql(250.0)
        end

        it "should have 255 if list have a description" do
          @list.evaluate!
          @list.description = Faker::Lorem.paragraphs.first
          @list.save
          @list.approve!
          @user.points.should eql(255.0)
        end

        it "should have 275 points if add new listing on the list" do
          @list.evaluate!
          @list.listings << Fabricate(:listing)
          @list.approve!
          @user.points.should eql(275.0)
        end

        it "should have 280 points if add new listing with comment on the list" do
          @list.evaluate!
          listing = Fabricate(:listing)
          listing.comments << Fabricate(:comment, user: @user)
          @list.listings << listing
          @list.approve!
          @user.points.should eql(280.0)
        end

        # Creating a list with at least 5 choices (250 points) + (500 points) for every 1000 votes
        it "should have 500 points if user created list with 5 listings gets 1000 votes" do
          give_votes_on_listings
          @list.total_listings_votes.should eql(1000.0)
          @user.points.should eql(750.0)
        end

        it "should have another 500 points if user created list with 5 listings gets 2000 votes" do
          give_votes_on_listings(200)
          give_votes_on_listings(200)
          @list.total_listings_votes.should eql(2000.0)
          @user.points.should eql(1250.0)
        end
      end

      describe "with 25 listings" do
        before(:each) do
          create_listing_listings(25)
        end

        ## Creating a list with at least 25 choices (750 points)
        it "should have 750 points if user create list with 25 choices" do
          @user.points.should eql(750.0)
        end

        ## Creating a list with at least 25 choices (750 points) + (1000 points) for every 1000 votes
        it "should have 1000 points if user created list with 25 listings gets 1000 votes" do
          give_votes_on_listings(40)
          @user.points.should eql(1750.0)
        end

        it "should be reduced by 25 if one listing on the list is removed" do
          @list.evaluate!
          listing = @list.listings.last
          @list.listings.delete(listing)
          @list.listings.count.should eql(24)
          @list.approve!
          @user.points.should eql(725.0)
        end
      end

    end

  end
end
