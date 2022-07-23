class UsersController < ApplicationController
  before_action :require_no_authentication

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
  

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end