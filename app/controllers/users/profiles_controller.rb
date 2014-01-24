class Users::ProfilesController < Users::BaseController

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Profile successfully updated."
      redirect_to users_profile_path
    else
      render :edit
    end
  end

  def show
  end

end
