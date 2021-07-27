Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["YOUR_CONSUMER_KEY"], ENV["YOUR_CONSUMER_SECRET"]
end

# OmniAuth.config.allowed_request_methods = [:post, :get]
# OmniAuth.config.silence_get_warning = true
