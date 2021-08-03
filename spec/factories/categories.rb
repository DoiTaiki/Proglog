FactoryBot.define do
  factory :category do
    category_tag { "a" * 30 }
    user { nil }
  end
end
