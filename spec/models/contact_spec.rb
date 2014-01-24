require 'spec_helper'

describe Contact do
  it "should have fields" do
    should have_attribute(:email)
    should have_attribute(:content)
  end

  it "should validate precence of" do
    should validate_presence_of(:email)
    should validate_presence_of(:content)
    should_not allow_value("test@test").for(:email)
  end
end
