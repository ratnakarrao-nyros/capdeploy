require 'spec_helper'

describe Item do

  it "should have fields" do
    should have_attribute(:name)
    should have_attribute(:description)
    should have_attribute(:image)
  end

  it "should validate precence of" do
    should validate_presence_of :name
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:name)
  end

  it "should have many lists" do
    should have_many(:listings)
    should have_many(:lists).through(:listings)
  end

end
