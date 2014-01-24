require 'spec_helper'

describe Admin do

  it "should have fields" do
    ## Database authenticatable
    should have_attribute(:email)
    should have_attribute(:encrypted_password)

    ## Trackable
    should have_attribute(:sign_in_count)
    should have_attribute(:current_sign_in_at)
    should have_attribute(:last_sign_in_at)
    should have_attribute(:current_sign_in_ip)
    should have_attribute(:last_sign_in_ip)

    ## Lockable
    should have_attribute(:failed_attempts)
    should have_attribute(:unlock_token)
    should have_attribute(:locked_at)
  end

  it "should validate precence of" do
    should validate_presence_of :email
  end

  it "should validate uniqueness of" do
    should validate_uniqueness_of(:email)
  end

end
