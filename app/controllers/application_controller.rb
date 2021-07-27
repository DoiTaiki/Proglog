class ApplicationController < ActionController::Base
  helper_method :current_user, :twitter_client_definition, :application_tweets
  before_action :application_tweets

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path, notice: "ログインして下さい。" unless current_user
  end

  def no_login_required
    redirect_to root_path, alert: "ログイン中は無効な操作です。" if current_user
  end

  def twitter_client_definition
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]    # API Key
      config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"] # API Secret Key
      config.access_token        = ENV["YOUR_ACCESS_TOKEN"]    # Access Token
      config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]   # Access Token Secret
    end
  end

  def application_tweets
    client = twitter_client_definition
    @tweets = client.user_timeline.take(10)
  end
end
