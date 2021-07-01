admin_user = User.find_or_create_by!(email: 'aaa@example.com') do |user|
  user.name = "aaa"
  user.blog_name = "aaablog"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true
end

50.times do |n|
  User.find_or_create_by!(email: "user_#{n}@example.com") do |user|
    user.name = "user_#{n}"
    user.blog_name = "USER_#{n}_blog"
    user.password = "password"
    user.password_confirmation = "password"
  end
end

admin_user_articles = 30.times do |n|
  admin_user.articles.find_or_create_by!(title: "管理ユーザーの記事_#{n}") do |article|
    article.text = "hello world!!"
  end
end

2.times do |n|
  user = User.find_by(email: "user_#{n}@example.com")
  30.times do |m|
    user.articles.find_or_create_by!(title: "user_#{n}の記事_#{m}") do |article|
      article.text = "hogehoge"
    end
  end
end
