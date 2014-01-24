class Users::BaseController < ApplicationController
  # Devise filter authenticate user
  before_filter :authenticate_user!
end
