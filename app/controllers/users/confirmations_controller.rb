class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :html, :js
end
