class Users::UsersController < Users::BaseController

  def edit
    @user = current_user
    @field = params[:field]
  end

  def update
    @user = current_user
    @field = params[:user][:field] if params[:user][:field].present?
    params[:user].delete(:field)
    successfully_updated = false
    if @field == "email"
      successfully_updated = @user.update_without_password(params[:user])
    else
      successfully_updated = @user.update_attributes(params[:user])
    end
    if successfully_updated
      sign_out(current_user) if current_user
      flash[:notice] = "Successfully updated user."
      respond_to do |format|
        format.html { redirect_to users_profile_path }
        format.js { render :js => "window.location = '#{users_profile_path}'" }
      end
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @user.destroy
    redirect_to root_path, :notice => "Your account has been removed."
  end

end
