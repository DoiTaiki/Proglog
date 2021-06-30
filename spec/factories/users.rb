FactoryBot.define do
  factory :user do
    name { "John" }
    sequence(:email) { |n| "john_#{n}@example.com" }
    blog_name { "John's blog" }
    profile { "Hallo!" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end
end
