class ArticlesController < ApplicationController
  before_action :login_required, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_article, only: [:edit, :update]

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
      flash_and_tweet_process("投稿")
      redirect_to user_path @article.user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash_and_tweet_process("編集")
      redirect_to user_path @article.user
    else
      render :edit
    end
  end

  def destroy
    unless current_user.admin?
      @article = current_user.articles.find(params[:id])
    else
      @article = Article.find(params[:id])
    end
      @article.destroy
      redirect_to user_path(@article.user), notice: "記事「#{@article.title}」を削除しました。"
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :text, :twitter_announce)
  end

  def set_article
    @article = current_user.articles.find(params[:id])
  end

  def twitter_client_definition
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]    # API Key
      config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"] # API Secret Key
      config.access_token        = ENV["YOUR_ACCESS_TOKEN"]    # Access Token
      config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]   # Access Token Secret
    end
  end

  def flash_and_tweet_process(new_or_edit)
    if @article.twitter_announce?
      client = twitter_client_definition
      client.update("記事「#{@article.title}」が#{new_or_edit}されました。是非ご覧下さい!! #{article_url @article} (ブログサイト「proglog」)(テスト投稿です。)")
      flash[:notice] = "記事「#{@article.title}」を#{new_or_edit}し、Twitterで告知しました。"
    else
      flash[:notice] = "記事「#{@article.title}」を#{new_or_edit}しました。"
    end
  end
end
