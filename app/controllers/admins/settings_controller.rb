class Admins::SettingsController < Admins::BaseController

  def show
    @setting = Setting.first
    authorize! :read, @setting
  end

  def edit
    @setting = Setting.first
    gon.setting_preferences = { :preferences => @setting.preferences }
  end

  def update
    params[:setting][:preferences] = JSON.parse(params[:setting][:preferences]) if params[:setting] and params[:setting][:preferences].kind_of? String
    @setting = Setting.first
    authorize! :update, @setting
    if @setting.update_attributes(params[:setting])
      redirect_to admins_settings_path, :notice => "Setting was successfully updated."
    else
      gon.setting_preferences = { :preferences => @setting.preferences }
      render :edit
    end
  end

end
