module TestHelpers
  def log_in_as(user)
    post login_path, params: { session: { email: user.email, password: user.password } }
  end

  def twitter_client_definition
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["YOUR_CONSUMER_KEY"]    # API Key
      config.consumer_secret     = ENV["YOUR_CONSUMER_SECRET"] # API Secret Key
      config.access_token        = ENV["YOUR_ACCESS_TOKEN"]    # Access Token
      config.access_token_secret = ENV["YOUR_ACCESS_SECRET"]   # Access Token Secret
    end
  end
end
