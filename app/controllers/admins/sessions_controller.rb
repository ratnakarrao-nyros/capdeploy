class Admins::SessionsController < Devise::SessionsController

  def new
    unless [new_admin_session_url,
            new_admin_unlock_url].include? request.referer
      session["admin_return_to"] = request.referer
    end
    super
  end

protected

  def after_sign_in_path_for(resource)
    session["admin_return_to"] || admins_root_url
  end

  def after_sign_out_path_for(resource)
    new_admin_session_url
  end

end
