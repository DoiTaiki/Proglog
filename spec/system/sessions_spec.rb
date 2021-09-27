require 'rails_helper'

describe "login system", type: :system do
  let!(:guest_user) { create(:user, :guest) }
  let(:login_user) { create(:user, :member) }

  describe "session new funciton" do
    before do
      visit login_path
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

    it "displays 'ログインする' button" do
      within ".login-form" do
        expect(page).to have_button "ログインする"
      end
    end

    context "when user already log-ins" do
      before do
        visit login_path
        fill_in 'メールアドレス', with: login_user.email
        fill_in 'パスワード', with: login_user.password
        click_button 'ログインする'
        visit login_path
      end

      it "redirects to root page" do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it "displays flash message about failure in link to page" do
        expect(page).to have_selector ".alert-danger", text: "ログイン中は無効な操作です。"
      end
    end
  end

  describe "session create function" do
    let(:filled_in_email) { login_user.email }
    let(:filled_in_password) { login_user.password }

    before do
      visit login_path
      fill_in "メールアドレス", with: filled_in_email
      fill_in "パスワード", with: filled_in_password
      click_button "ログインする"
    end

    context "when email and password are correct" do
      it "redirects to user's blog page" do
        expect(page).to have_current_path user_path(login_user), ignore_query: true
      end

      it "displays flash message about success in login" do
        expect(page).to have_selector ".alert-success", text: "ログインしました。"
      end
    end

    context "when email is incorrect" do
      let(:filled_in_email) { "incorrect" }

      it "displays flash message about incorrect email" do
        expect(page).to have_selector ".alert-danger", text: "メールアドレスが未登録もしくは正しくありません。"
      end
    end

    context "when password is incorrect" do
      let(:filled_in_password) { "incorrect" }

      it "displays flash message about incorrect password" do
        expect(page).to have_selector ".alert-danger", text: "パスワードが正しくありません。"
      end
    end
  end

  describe "session destroy function" do
    let(:filled_in_email) { login_user.email }
    let(:filled_in_password) { login_user.password }

    before do
      visit login_path
      fill_in "メールアドレス", with: filled_in_email
      fill_in "パスワード", with: filled_in_password
      click_button "ログインする"
      click_link "ログアウト"
    end

    it "redirects to article index page" do
      expect(page).to have_current_path root_path
    end

    it "displays flash message about success in logout" do
      expect(page).to have_selector ".alert-success", text: "ログアウトしました。"
    end
  end

  describe "session new_as_guest funciton" do
    before do
      visit guest_login_path
    end

    it "displays 'メールアドレス' form" do
      within ".login-form" do
        expect(page).to have_field "メールアドレス", with: "guest_user@example.com"
      end
    end

    it "displays 'パスワード' form" do
      within ".login-form" do
        expect(page).to have_field "パスワード", with: "password"
      end
    end

    it "displays 'ゲストとしてログインする' button" do
      within ".login-form" do
        expect(page).to have_button "ゲストとしてログインする"
      end
    end

    context "when email and password are correct" do
      before do
        click_button "ゲストとしてログインする"
      end

      it "redirects to guest_user's blog page" do
        expect(page).to have_current_path user_path(guest_user), ignore_query: true
      end

      it "displays flash message about success in login" do
        expect(page).to have_selector ".alert-success", text: "ログインしました。"
      end
    end
  end
end
