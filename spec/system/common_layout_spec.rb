require 'rails_helper'

describe "common layout", type: :system do
  let(:login_user) { create(:user) }
  let(:tweets) { twitter_client_definition.user_timeline.take(10) }

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

    it "displays a 'Twitter' link on navigation bar" do
      within ".navbar" do
        expect(page).to have_link "Twitter", href: tweets.first.user.uri
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

    it "displays application's twitter account link on footer" do
      expect(page).to have_link "@#{tweets.first.user.screen_name}", href: tweets.first.user.uri
    end

    it "displays '表示↔︎非表示' button on footer" do
      expect(page).to have_button "表示↔︎非表示"
    end

    it "displays tweet table on footer" do
      expect(page).to have_selector ".tweet-table", text: tweets.first.text
      expect(page).to have_selector ".tweet-table", text: tweets.first.created_at.in_time_zone('Tokyo').strftime("%Y年%m月%d日-%H:%M")
    end

    # context "when user clicks the row in tweet table" do
    #   before do
    #     find("#row-#{tweets.first.id}").click
    #   end
    #
    #   it "jumps to the tweet link" do
    #     expect(page).to have_current_path tweets.first.uri, ignore_query: true
    #   end
    # end

    # context "when user click '表示↔︎非表示' button once" do
    #   before do
    #     click_button "表示↔︎非表示"
    #   end
    #
    #   it "doesn't display tweet table" do
    #     expect(page).to have_no_selector ".tweet-table"
    #   end
    # end

    context "when user click '表示↔︎非表示' button twice" do
      before do
        2.times do
          click_button "表示↔︎非表示"
        end
      end

      it "displays tweet table on footer" do
        expect(page).to have_selector ".tweet-table"
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
