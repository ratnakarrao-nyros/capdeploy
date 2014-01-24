class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    provider_callbacks(:twitter)
  end

  def facebook
    provider_callbacks(:facebook)
  end

private
  def provider_callbacks(provider)
    # twitter request env is too large, got an error when try to store into a cookies
    request.env["omniauth.auth"].delete("extra") if provider == :twitter
    request.env["omniauth.auth"]["extra"]['raw_info'] = request.env["omniauth.auth"]["extra"]['raw_info'].select {|k,v| ["email"].include?(k) } if provider == :facebook

    # store request.env on session["devise.omniauth_data"]
    session["devise.omniauth_data"] = request.env["omniauth.auth"]

    resource = User.find_or_create_by_omniauth(provider, session["devise.omniauth_data"])
    if resource and resource.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => provider.to_s.titleize
      sign_in(resource, :bypass => true)
      session["devise.omniauth_data"] = nil
      redirect_to signed_in_root_path("users")
    else
      # display full error messages inline
      redirect_to new_user_registration_by_provider_url(provider: provider), :alert => resource.errors.full_messages.join(", ")
    end
  end

end
