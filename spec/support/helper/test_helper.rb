module TestHelpers
  def log_in_as(user)
    post login_path, params: { session: { email: user.email, password: user.password } }
  end
end
