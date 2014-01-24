require 'spec_helper'

describe Profile do

  it "should have fields" do
    should have_attribute(:user_id)
    should have_attribute(:first_name)
    should have_attribute(:last_name)
    should_not have_attribute(:phone)
    should have_attribute(:birthday)
    should have_attribute(:sex)
    should_not have_attribute(:address)
    should have_attribute(:city)
    should_not have_attribute(:zip)
    should have_attribute(:state)
    should have_attribute(:website)
  end

  it "should belongs to user" do
    should belong_to(:user)
  end
end
