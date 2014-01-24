require 'spec_helper'

describe Admins::SettingsController do

  before(:each) do
    @setting = Fabricate(:setting)
    login_admin
  end

  describe "GET show" do
    it "should render show template" do
      get :show
      response.should render_template(:show)
    end
  end

  describe "GET edit" do
    it "should render edit template" do
      get :edit
      response.should render_template(:edit)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should redirect to show template" do
        @setting.preferences.merge!(:new_key => "new_value")
        Setting.any_instance.stub(:valid?).and_return(true)
        put :update, :setting => Fabricate.attributes_for(:setting, :name => @setting.name, :preferences => @setting.preferences)
        assigns(:setting).preferences.keys.should include("new_key")
        response.should redirect_to(admins_settings_path)
      end
    end

    describe "with invalid params" do
      it "should re-render edit template" do
        Setting.any_instance.stub(:valid?).and_return(false)
        put :update, :setting => nil
        response.should render_template(:edit)
      end
    end
  end

end
