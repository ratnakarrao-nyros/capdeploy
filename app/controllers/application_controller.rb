class ApplicationController < ActionController::Base
  # CanCan AccessDenied
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  before_filter :correct_safari_and_ie_accept_headers
  after_filter :set_xhr_flash

  protect_from_forgery
  layout Proc.new { |controller| ( devise_controller? and !controller_path.include? "users" ) ? "login" : "application" }

  # include all helper method all the time
  helper :all

  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
  end
end
