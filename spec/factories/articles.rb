FactoryBot.define do
  factory :article do
    title { "a" * 100 }
    description { "a" * 255 }
    text { "a" * 1000 }
    user { nil }
  end
end
