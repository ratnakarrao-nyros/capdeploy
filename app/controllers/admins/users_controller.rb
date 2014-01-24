class Admins::UsersController < Admins::BaseController

  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context) }
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @user.build_profile
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admins_user_path(@user), :notice => "User was successfully created."
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admins_user_path(@user), :notice => "User was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admins_users_path, :notice => "User destroyed!"
  end

end
