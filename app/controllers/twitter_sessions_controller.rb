class TwitterSessionsController < ApplicationController
  before_action :no_login_required

  def create
    unless request.env['omniauth.auth'][:uid]
      redirect_to root_path, alert: "連携に失敗しました。"
      return
    end
    session[:uid] = request.env['omniauth.auth'][:uid]
    user = User.find_by(uid: session[:uid])
    if user
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "ログインしました。"
      session[:uid] = nil
    else
      redirect_to new_link_account_path, alert: "既存のアカウントとの関連付けが必要です。"
    end
  end

  def new_link_account
  end

  def create_link_account
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      if session_params[:password_confirmation] != session_params[:password]
        flash.now[:alert] = "パスワード(確認)がパスワードと異なります。"
        render :new_link_account
      else
        user.update(uid_params)
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "認証情報を登録し、ログインしました。"
        session[:uid] = nil
      end
    else
      if user && !user.authenticate(session_params[:password])
        flash.now[:alert] = "パスワードが正しくありません。"
      elsif !user
        flash.now[:alert] = "メールアドレスが未登録もしくは正しくありません。"
      end
      render :new_link_account
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :password_confirmation, :uid)
  end

  def uid_params
    params.require(:session).permit(:password, :password_confirmation, :uid)
  end
end
