class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js, :only => [:new, :create]
  before_filter :check_session_devise_omniauth_data, :only => [:new_by_provider, :create_by_provider]

  def new_by_provider
    resource = build_resource({})
    respond_with_navigational(resource){ render :new_by_provider }
  end

  def create_by_provider
    resource = build_resource({})
    resource.email = params[:user][:email]
    resource.password = Devise.friendly_token[0,20]
    resource.skip_confirmation!
    resource.provider = session["devise.omniauth_data"].provider
    resource.uid = session["devise.omniauth_data"].uid
    if resource.save
      if resource.active_for_authentication?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => session["devise.omniauth_data"].provider.to_s.titleize
        sign_in(resource_name, resource)
        session["devise.omniauth_data"] = nil
        respond_with resource, :location => after_sign_up_path_for(resource)
      end
    else
      respond_with_navigational(resource){ render :new_by_provider }
    end
  end

protected

  def check_session_devise_omniauth_data
    redirect_to new_user_registration_path unless session["devise.omniauth_data"]
  end

  def after_sign_up_path_for(resource)
    users_root_url
  end

end
