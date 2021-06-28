class ApplicationController < ActionController::Base
  helper_method [:current_user, :admin_user?]

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path, notice: "ログインして下さい。" unless current_user
  end

  def admin_user?
    current_user&.admin?
  end
end
