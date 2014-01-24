require 'spec_helper'

describe Users::UsersController do

  before (:each) do
    login_user
  end

  describe "GET edit" do
    it "should render edit own email, password template" do
      ["email", "password"].each do |field|
        get :edit, :field => field, :format => :js
        response.should be_success
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should update email if valid" do
        put :update, :user => { :email => "new@email.com", :field => "email" }, :format => :js
        last_email.to.should include("new@email.com")
        flash[:notice].should_not be_nil
      end
    end

    describe "with invalid params" do
      it "should not update email if already taken" do
        user = Fabricate(:user, :email => "testing@email.com")
        User.any_instance.stub(:valid?).and_return(false)
        put :update, :user => { :email => "testing@email.com", :field => "email" }, :format => :js
        response.should render_template(:edit)
      end
    end
  end

  it "should delete user account" do
    user_id = @user.id
    delete :destroy
    lambda do
      User.find(user_id)
    end.should raise_error(ActiveRecord::RecordNotFound)
    flash[:notice].should_not be_nil
    response.should redirect_to(root_path)
  end
end
