class UsersController < ApplicationController
  before_action :require_no_authentication, only: [:new, :create]
  before_action :require_authentication, only: [:edit, :update]
  before_action :set_user!, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to the app, #{@user.name}"
      redirect_to root_path
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  
  def edit; end

  def update
      if @user.update user_params
        flash[:success] = "Profile was successfully updated"
        redirect_to root_path
      else
        flash[:error] = "Something went wrong"
        render 'edit'
      end
  end
  

  private

  def set_user!
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :old_password)
  end
end
