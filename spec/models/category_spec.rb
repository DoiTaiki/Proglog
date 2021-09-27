require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) { create(:user, :member) }
  let(:category) { build(:category, user: user) }
  let(:no_user_category) { build(:category) }
  let(:no_category_tag_category) { build(:category, user: user, category_tag: nil) }
  let(:too_long_category_tag_category) { build(:category, user: user, category_tag: "a" * 31) }

  it "is valid category with a category_tag which is associated with a user" do
    expect(category).to be_valid
  end

  it "is invalid category which is not associated with any user" do
    no_user_category.valid?
    expect(no_user_category.errors[:user]).to include("を入力してください")
  end

  it "is invalid category without a category_tag" do
    no_category_tag_category.valid?
    expect(no_category_tag_category.errors[:category_tag]).to include("を入力してください")
  end

  it "is invalid category with a too long category_tag" do
    too_long_category_tag_category.valid?
    expect(too_long_category_tag_category.errors[:category_tag]).to include("は30文字以内で入力してください")
  end
end
