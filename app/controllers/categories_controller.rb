class CategoriesController < ApplicationController
  before_action :login_required, only: [:create, :edit, :update, :destroy]
  before_action :set_category, only: [:edit, :update, :destroy]

  def show
    @category = Category.find(params[:id])
    @q = @category.articles.ransack(params[:q])
    @articles = @q.result(distinct: true).page(params[:page])
    @user = @category.user
  end

  def create
    @category = current_user.categories.new(category_params)

    if @category.save
      redirect_back fallback_location: root_path, notice: "カテゴリー「#{@category.category_tag}」を登録しました。"
    elsif @category.category_tag.length > 30
      redirect_back fallback_location: root_path, alert: "カテゴリー名は30文字以内で入力してください。"
    elsif @category.category_tag.blank?
      redirect_back fallback_location: root_path, alert: "カテゴリー名を入力してください。"
    else
      redirect_back fallback_location: root_path, alert: "不正なカテゴリー名です。"
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to user_path(@category.user), notice: "カテゴリー「#{@category.category_tag}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to user_path(@category.user), notice: "カテゴリー「#{@category.category_tag}」を削除しました。"
  end

  private

  def category_params
    params.require(:category).permit(:category_tag)
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end
end
