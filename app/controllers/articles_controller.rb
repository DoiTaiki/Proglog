class ArticlesController < ApplicationController
  before_action :login_required, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @q = Article.all.ransack(params[:q])
    @articles = @q.result(distinct: true).page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      redirect_to articles_path, notice: "記事「#{@article.title}」を投稿しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to article_path @article, notice: "記事「#{@article.title}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "記事「#{@article.title}」を削除しました。"
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :text)
  end

  def set_article
    @article = current_user.articles.find(params[:id])
  end
end
