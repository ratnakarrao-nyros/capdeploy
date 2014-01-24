require 'spec_helper'

describe Users::ProfilesController do

  before(:each) do
    login_user
  end

  describe "GET edit" do
    it "should render edit template if authorized" do
      get :edit
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    it "should redirect to show template if profile params are valid" do
      put :update, :profile => { :first_name => "jack" }
      assigns(:profile).first_name.should == "jack"
      response.should redirect_to(users_profile_path)
      flash[:notice].should_not be_nil
    end

    it "should re-render edit template if profile params are invalid" do
      profile = @user.build_profile
      profile.first_name = "tobechanged"
      @user.save!
      Profile.any_instance.stub(:valid?).and_return(false)
      put :update, :profile => nil
      response.should render_template(:edit)
    end
  end

end
