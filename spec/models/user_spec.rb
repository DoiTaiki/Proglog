require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user, name: "user_1", email: "user_1@example.com") }
  let(:no_name_user) { build(:user, name: nil) }
  let(:too_long_name_user) { build(:user, name: "a" * 51) }
  let(:same_name_user) { build(:user, name: "user_1") }
  let(:no_email_user) { build(:user, email: nil) }
  let(:same_email_user) { build(:user, email: "user_1@example.com") }
  let(:wrong_format_email_user) { build(:user, email: "aaa") }
  let(:no_blog_name_user) { build(:user, blog_name: nil) }
  let(:too_long_blog_name_user) { build(:user, blog_name: "a" * 31) }
  let(:too_long_profile_user) { build(:user, profile: "a" * 256) }
  let(:no_password_user) { build(:user, password: nil) }
  let(:too_short_password_user) { build(:user, password: "a") }
  let(:no_password_confirmation_user) { build(:user, password_confirmation: nil) }
  let(:different_password_confirmation_user) { build(:user, password: "a", password_confirmation: "b") }

  it "is valid with a name, email, password, password_confirmation" do
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    no_name_user.valid?
    expect(no_name_user.errors[:name]).to include("を入力してください")
  end

  it "is invalid with a too long name" do
    too_long_name_user.valid?
    expect(too_long_name_user.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "is invalid with a same name" do
    same_name_user.valid?
    expect(same_name_user.errors[:name]).to include("はすでに存在します")
  end

  it "is invalid without a email" do
    no_email_user.valid?
    expect(no_email_user.errors[:email]).to include("を入力してください")
  end

  it "is invalid with a same email" do
    same_email_user.valid?
    expect(same_email_user.errors[:email]).to include("はすでに存在します")
  end

  it "is invalid with a wrong_format_email" do
    wrong_format_email_user.valid?
    expect(wrong_format_email_user.errors[:email]).to include("は不正な値です")
  end

  it "is invalid without a blog name" do
    no_blog_name_user.valid?
    expect(no_blog_name_user.errors[:blog_name]).to include("を入力してください")
  end

  it "is invalid with a too long blog name" do
    too_long_blog_name_user.valid?
    expect(too_long_blog_name_user.errors[:blog_name]).to include("は30文字以内で入力してください")
  end

  it "is invalid with a too long profile" do
    too_long_profile_user.valid?
    expect(too_long_profile_user.errors[:profile]).to include("は255文字以内で入力してください")
  end

  it "is invalid without a password" do
    no_password_user.valid?
    expect(no_password_user.errors[:password]).to include("を入力してください")
  end

  it "is invalid with a too short password" do
    too_short_password_user.valid?
    expect(too_short_password_user.errors[:password]).to include("は6文字以上で入力してください")
  end

  it "is invalid without a password_confirmation" do
    no_password_confirmation_user.valid?
    expect(no_password_confirmation_user.errors[:password_confirmation]).to include("を入力してください")
  end

  it "is invalid with a password_confirmation which differs from password" do
    different_password_confirmation_user.valid?
    expect(different_password_confirmation_user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
  end
end
