require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { create(:user) }
  let(:article) { build(:article, user: user) }
  let(:no_user_article) { build(:article) }
  let(:no_title_article) { build(:article, user: user, title: nil) }
  let(:too_long_title_article) { build(:article, user: user, title: "a" * 101) }
  let(:too_long_description_article) { build(:article, user: user, description: "a" * 256) }
  let(:no_text_article) { build(:article, user: user, text: nil) }

  it "is valid article with a title, text which is associated with a user" do
    expect(article).to be_valid
  end

  it "is invalid article which is not associated with any user" do
    no_user_article.valid?
    expect(no_user_article.errors[:user]).to include("を入力してください")
  end

  it "is invalid article without a title" do
    no_title_article.valid?
    expect(no_title_article.errors[:title]).to include("を入力してください")
  end

  it "is invalid article with a too long title" do
    too_long_title_article.valid?
    expect(too_long_title_article.errors[:title]).to include("は100文字以内で入力してください")
  end

  it "is invalid article with a too long description" do
    too_long_description_article.valid?
    expect(too_long_description_article.errors[:description]).to include("は255文字以内で入力してください")
  end

  it "is invalid article without a text" do
    no_text_article.valid?
    expect(no_text_article.errors[:text]).to include("を入力してください")
  end

end
