require 'spec_helper'

describe Setting do
  it "should have fields" do
    should have_attribute(:name)
    should have_attribute(:preferences)
  end

  it "should validate precence of" do
    should validate_presence_of :name
    should validate_presence_of :preferences
  end
end
