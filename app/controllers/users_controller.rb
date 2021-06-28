class UsersController < ApplicationController
  before_action :login_required, only: [:edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_path @user, notice: "ユーザー「#{@user.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])

    unless @user.admin?
      @user.destroy
      redirect_to users_path, notice: "ユーザー「#{@user.name}」を削除しました。"
    else
      redirect_to users_path, notice: "管理ユーザーは削除できません。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile, :password, :password_confirmation)
  end

  def correct_user?
    redirect_to root_path, notice: "該当アカウントの編集・削除権限を持っていません。" unless User.find(params[:id]) == current_user || admin_user?
  end
end
