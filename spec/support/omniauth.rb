module OmniAuthTwitterMocks
  def omniauth_twitter_mock
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: "twitter",
      uid: "123545"
    })
  end
end
