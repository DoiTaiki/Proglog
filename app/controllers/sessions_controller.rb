class SessionsController < ApplicationController
  before_action :no_login_required, only: [:new, :new_as_guest, :create]

  def new
  end

  def new_as_guest
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "ログインしました。"
    else
      if user && !user.authenticate(session_params[:password])
        flash.now[:alert] = "パスワードが正しくありません。"
      elsif !user
        flash.now[:alert] = "メールアドレスが未登録もしくは正しくありません。"
      end
      render :new
    end
  end

  def destroy
    if current_user
      reset_session
      redirect_to root_path, notice: "ログアウトしました。"
    else
      redirect_to root_path, alert: "ログインしていません。"
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
