require 'rails_helper'

describe "twitter session system", type: :system do
  let(:login_user) { create(:user) }
  let!(:login_user_linked_by_twitter) { create(:user, uid: "123545") }

  describe "twitter session create funciton" do
    before do
      Rails.application.env_config["omniauth.auth"] = omniauth_twitter_mock
      visit root_path
    end

    context "when auth hash doesn't exist" do
      before do
        Rails.application.env_config["omniauth.auth"][:uid] = nil
        click_link "Twitterアカウントによるログイン"
      end

      it "redirects to root page" do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it "displays flash message about failure in link" do
        expect(page).to have_selector ".alert-danger", text: "連携に失敗しました。"
      end
    end

    context "when user has a linked twitter account" do
      before do
        click_link "Twitterアカウントによるログイン"
      end

      it "redirects to user's page" do
        expect(page).to have_current_path user_path(login_user_linked_by_twitter), ignore_query: true
      end

      it "displays flash message about success in log-in" do
        expect(page).to have_selector ".alert-success", text: "ログインしました。"
      end
    end

    context "when user doesn't have any linked twitter account" do
      before do
        Rails.application.env_config["omniauth.auth"][:uid] = "111111"
        click_link "Twitterアカウントによるログイン"
      end

      it "redirects to page for new link account page" do
        expect(page).to have_current_path new_link_account_path, ignore_query: true
      end

      it "displays flash message about failure in link" do
        expect(page).to have_selector ".alert-danger", text: "既存のアカウントとの関連付けが必要です。"
      end
    end
  end

  describe "twitter session new link account funciton" do
    before do
      visit new_link_account_path
    end

    it "displays 'メールアドレス' form" do
      within ".login-form" do
        expect(page).to have_field "メールアドレス"
      end
    end

    it "displays 'パスワード' form" do
      within ".login-form" do
        expect(page).to have_field "パスワード"
      end
    end

    it "displays 'パスワード(確認)' form" do
      within ".login-form" do
        expect(page).to have_field "パスワード(確認)"
      end
    end

    it "displays '関連付けてログインする' button" do
      within ".login-form" do
        expect(page).to have_button "関連付けてログインする"
      end
    end

    context "when user log-ins" do
      before do
        visit login_path
        fill_in 'メールアドレス', with: login_user.email
        fill_in 'パスワード', with: login_user.password
        click_button 'ログインする'
        visit new_link_account_path
      end

      it "redirects to root page" do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it "displays flash message about failure in link to page" do
        expect(page).to have_selector ".alert-danger", text: "ログイン中は無効な操作です。"
      end
    end
  end

  describe "twitter session create link account funciton" do
    let(:filled_in_email) { login_user.email }
    let(:filled_in_password) { login_user.password }
    let(:filled_in_password_confirmation) { login_user.password }

    before do
      visit new_link_account_path
      fill_in "メールアドレス", with: filled_in_email
      fill_in "パスワード", with: filled_in_password
      fill_in "パスワード(確認)", with: filled_in_password_confirmation
      click_button "関連付けてログインする"
    end

    context "password_confirmation is different with password" do
      let(:filled_in_password_confirmation) { "different" }

      it "displays flash message about incorrect  password_confirmation" do
        expect(page).to have_selector ".alert-danger", text: "パスワード(確認)がパスワードと異なります。"
      end
    end

    context "when email and password, password_confirmation are correct" do
      it "redirects to user's blog page" do
        expect(page).to have_current_path user_path(login_user), ignore_query: true
      end

      it "displays flash message about success in login" do
        expect(page).to have_selector ".alert-success", text: "認証情報を登録し、ログインしました。"
      end
    end

    context "when password is incorrect" do
      let(:filled_in_password) { "incorrect" }

      it "displays flash message about incorrect password" do
        expect(page).to have_selector ".alert-danger", text: "パスワードが正しくありません。"
      end
    end

    context "when email is incorrect" do
      let(:filled_in_email) { "incorrect" }

      it "displays flash message about incorrect email" do
        expect(page).to have_selector ".alert-danger", text: "メールアドレスが未登録もしくは正しくありません。"
      end
    end
  end
end
