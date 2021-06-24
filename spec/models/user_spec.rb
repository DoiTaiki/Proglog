require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:no_name_user) { build(:user, name: nil) }
  let(:too_long_name_user) { build(:user, name: "a" * 51) }
  let(:no_email_user) { build(:user, email: nil) }
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

  it "is invalid a too long name" do
    too_long_name_user.valid?
    expect(too_long_name_user.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "is invalid without a email" do
    no_email_user.valid?
    expect(no_email_user.errors[:email]).to include("を入力してください")
  end

  it "is invalid without a password" do
    no_password_user.valid?
    expect(no_password_user.errors[:password]).to include("を入力してください")
  end

  it "is invalid a too short password" do
    too_short_password_user.valid?
    expect(too_short_password_user.errors[:password]).to include("は6文字以上で入力してください")
  end

  it "is invalid without a password_confirmation" do
    no_password_confirmation_user.valid?
    expect(no_password_confirmation_user.errors[:password_confirmation]).to include("を入力してください")
  end

  it "is invalid a password_confirmation which is differ from password" do
    different_password_confirmation_user.valid?
    expect(different_password_confirmation_user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
  end
end
