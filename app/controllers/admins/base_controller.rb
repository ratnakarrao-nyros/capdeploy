class Admins::BaseController < ApplicationController
  # Devise filter authenticate admin
  before_filter :authenticate_admin!

  layout "admin"

  # overrides CanCan current_ability
  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end

end

