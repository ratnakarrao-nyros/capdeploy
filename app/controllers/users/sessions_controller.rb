class Users::SessionsController < Devise::SessionsController
  respond_to :html, :js

  def create
    # it will throw from warden if using format JS
    # and return 401 and error messages in the responseText
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in)
    sign_in(resource_name, resource)
    respond_to do |format|
      format.html { respond_with resource, :location => after_sign_in_path_for(resource) }
      format.js
    end
  end

end
