require 'rails_helper'

describe "common layout", type: :system do
  let(:login_user) { create(:user) }

  before do
    visit user_path login_user
  end

  context "when user doesn't login" do
    it "displays a '記事一覧' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "記事一覧", href: articles_path
      end
    end

    it "displays a '投稿者一覧' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "投稿者一覧", href: users_path
      end
    end

    it "displays a 'ログイン' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "ログイン", href: login_path
      end
    end

    it "displays a '新規登録' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "新規登録", href: new_user_path
      end
    end

    it "doesn't display user's blog name on navigation bar" do
      within ".navbar" do
        expect(page).to have_no_link login_user.blog_name
      end
    end

    it "doesn't display a '記事を書く' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_no_link "記事を書く"
      end
    end

    it "doesn't display a 'ログアウト' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_no_link "ログアウト"
      end
    end
  end

  context "when user logins" do
    before do
      visit login_path
      fill_in "メールアドレス", with: login_user.email
      fill_in "パスワード", with: login_user.password
      click_button "ログインする"
    end

    it "doesn't display a 'ログイン' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_no_link "ログイン"
      end
    end

    it "doesn't display a '新規登録' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_no_link "新規登録"
      end
    end

    it "displays user's blog name on navigation bar" do
      within ".navbar" do
        expect(page).to have_link login_user.blog_name, href: user_path(login_user)
      end
    end

    it "displays a '記事を書く' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "記事を書く", href: new_article_path
      end
    end

    it "displays a 'ログアウト' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "ログアウト", href: logout_path
      end
    end
  end
end
