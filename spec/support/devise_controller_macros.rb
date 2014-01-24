module DeviseControllerMacros

  mattr_accessor :admin, :user

  def login_admin
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @admin = Fabricate(:admin)
    sign_in @admin
  end

  def login_user
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = Fabricate(:user)
    @user.confirm!
    sign_in @user
  end
end
