class SessionsController < ApplicationController  
  def new
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
    reset_session
    redirect_to root_path, notice: "ログアウトしました。"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
