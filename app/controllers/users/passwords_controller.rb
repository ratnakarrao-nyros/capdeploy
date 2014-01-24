class Users::PasswordsController < Devise::PasswordsController
  respond_to :html, :js
end
