class ApplicationController < ActionController::Base
  include ErrorHandling

  private

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id].present?
  end

  def user_signed_in?
    current_user.present?
  end

  helper_method :current_user, :user_signed_in?
end
