require 'spec_helper'

describe Comment do

  it "should have fields" do
    should have_attribute(:user_id)
    should have_attribute(:content)
    should have_attribute(:commentable_id)
    should have_attribute(:commentable_type)
    should have_attribute(:position)
  end

  it "should validate precence of" do
    should validate_presence_of :user_id
  end

  it "should belongs to user & commentable" do
    should belong_to(:user)
    should belong_to(:commentable)
  end

end
