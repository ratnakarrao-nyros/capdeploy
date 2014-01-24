require 'spec_helper'

describe List do

  it "should have fields" do
    should have_attribute(:user_id)
    should have_attribute(:name)
    should have_attribute(:description)
    should have_attribute(:category_id)
    should have_attribute(:state)
  end

  it "should validate precence of" do
    should validate_presence_of :name
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:name)
  end

  it "should belongs to user & category" do
    should belong_to(:user)
    should belong_to(:category)
  end

  it "should have many items & comments" do
    should have_many(:listings).dependent(:destroy)
    should have_many(:items).through(:listings)
  end

  def populate_list_and_destroy_it
    @list = Fabricate(:list)
    @array_of_listings = (1..3).map do
      Fabricate(:listing, :list => @list)
    end
    @list.destroy
  end

  it "should destroying all listing when list is destroyed" do
    populate_list_and_destroy_it
    @array_of_listings.each do |listing|
      Listing.all.should_not include(listing)
    end
  end

  it "should not destroying all items when list is destroyed" do
    populate_list_and_destroy_it
    @array_of_listings.each do |listing|
      Item.all.should include(listing.item)
    end
  end

  describe "state transition" do
    before(:each) do
      @list = Fabricate(:list)
    end

    describe "pending" do
      it "should initialize with state pending" do
        @list.state.should eql("pending")
      end

      it "user should not have any points" do
        @list.user.points.should eql(0.0)
      end
    end

    describe "approved" do
      before(:each) do
        @list.approve!
      end

      it "should be change to approved if list is approve!" do
        @list.state.should eql("approved")
      end

      it "user should receive list points" do
        @list.user.points.should eql(@list.points)
      end

      it "user should be able to evaluate the list and the state will revert to pending" do
        @list.user.points.should eql(@list.points)
        @list.evaluate!
        @list.state.should eql("pending")
        @list.user.points.should eql(0.0)
      end
    end

    describe "rejected" do
      before(:each) do
        @list.reject!
      end

      it "should be change to rejected if list is reject!" do
        @list.state.should eql("rejected")
      end

      it "user should not receive list points" do
        @list.user.points.should eql(0.0)
      end

      it "should be able to evaluated and the state return to pending" do
        @list.evaluate!
        @list.state.should eql("pending")
      end
    end
  end

  describe "pointings system" do

    def create_listing_listings(list, num)
      num.times do
        Fabricate(:listing, list: list)
      end
    end

    it "should have 50 points for each five listings on the list" do
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 5)
      list.points.should eql(250)
    end

    it "should have 25 points for the next 20 listings on the list" do
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 25)
      list.points.should eql(750)
    end

    it "should not add any points if listings more than 25 on the list" do
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 30)
      list.points.should eql(750)
    end

    it "should have 5 extra points if list have a description" do
      list = Fabricate(:list)
      create_listing_listings(list, 5)
      list.points.should eql(255)
    end

    it "should have 5 extra points if user give comment on the listing" do
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 5)
      list.listings.first.comments << Fabricate(:comment, user: list.user)
      list.points.should eql(255)
    end

    it "should not add any points if comment comes from other user" do
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 5)
      list.listings.first.comments << Fabricate(:comment)
      list.points.should eql(250)
    end

    it "should have 10 extra points if listing on a list have an image" do
      # simple test for testing image value on item
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 4)
      item = Fabricate(:item, with_image: true)
      list.listings << Fabricate(:listing, item: item)
      list.points.should eql(260)
    end

    it "should reduced 65 points if some listing have been removed from the list" do
      list = Fabricate(:list, description: nil)
      create_listing_listings(list, 5)
      listing = Fabricate(:listing, item: Fabricate(:item, with_image: true))
      list.listings << listing
      listing1 = Fabricate(:listing)
      listing1.comments << Fabricate(:comment, user: list.user)
      list.listings << listing1
      list.listings.delete(listing)
      list.listings.delete(listing1)
      list.points.should eql(250)
    end
  end

end
