FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    blog_name { "User's blog" }
    profile { "Hello!" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    uid { nil }
  end
end
