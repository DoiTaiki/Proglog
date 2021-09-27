FactoryBot.define do
  factory :user do
    trait :member do
      sequence(:name) { |n| "user_#{n}" }
      sequence(:email) { |n| "user_#{n}@example.com" }
      blog_name { "User's blog" }
      profile { "Hello!" }
      password { "password" }
      password_confirmation { "password" }
      admin { false }
      uid { nil }
    end

    trait :guest do
      name { "guest_user" }
      email { "guest_user@example.com" }
      blog_name { "guest_user's blog" }
      profile { "Welcome!" }
      password { "password" }
      password_confirmation { "password" }
      admin { false }
      uid { nil }
    end
  end
end
