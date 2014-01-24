require 'spec_helper'

describe Listing do

  it "should have fields" do
    should have_attribute(:list_id)
    should have_attribute(:item_id)
    should have_attribute(:position)
  end

  it "should belongs to list and item" do
    should belong_to(:list)
    should belong_to(:item)
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:item_id).scoped_to(:list_id)
  end

  describe "dependent destroy" do
    before(:each) do
      @listing = Fabricate(:listing)
    end

    it "should be destroyed when list is destroyed" do
      @listing.list.destroy
      Listing.all.should_not include(@listing)
    end

    it "should not destroying all items when listing is destroyed" do
      @listing.destroy
      Item.all.should include(@listing.item)
    end

    it "should destroying all comments when listing is destroyed" do
      comment = Fabricate(:comment)
      @listing.comments << comment
      @listing.destroy
      Comment.all.should_not include(comment)
    end
  end

end
