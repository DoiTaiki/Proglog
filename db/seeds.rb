admin_user = User.find_or_create_by(email: 'aaa@example.com') do |user|
  user.name = "aaa"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
end
