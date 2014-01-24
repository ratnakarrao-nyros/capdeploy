require 'spec_helper'

describe Category do

  it "should have fields" do
    should have_attribute(:name)
  end

  it "should validate precence of" do
    should validate_presence_of :name
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:name)
  end

  it "should have many list" do
    should have_many(:lists)
  end

end
