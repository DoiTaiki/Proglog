require 'rails_helper'

describe "article management system", type: :system do
  let(:user) { create(:user, name: "user") }
  let(:other_user) { create(:user, name: "other_user", email: "other_user@example.com") }
  let(:admin_user) { create(:user, email: "admin_user@example.com", admin: true) }
  let!(:article) { create(:article, user: user) }
  let!(:other_article) { create(:article, title: "other_article's title",  user: other_user) }
  let(:tweeted_article) { create(:article, title: "tweet announce", text: "tweet announce", twitter_announce: true, user: user) }

  describe "basic function" do
    describe "article index function" do
      before do
        visit articles_path
      end

      it "displays a link of user's article title" do
        within ".article-table" do
          expect(page).to have_link article.title, href: article_path(article)
        end
      end

      it "displays a link of other_user's article title" do
        within ".article-table" do
          expect(page).to have_link other_article.title, href: article_path(other_article)
        end
      end

      it "displays a link of user's name" do
        within ".article-table" do
          expect(page).to have_link article.user.name, href: user_path(article.user)
        end
      end

      it "displays a other_user's name" do
        within ".article-table" do
          expect(page).to have_link other_article.user.name, href: user_path(other_article.user)
        end
      end

      it "displays a user's article update time" do
        within ".article-table" do
          expect(page).to have_content time_format article.updated_at
        end
      end

      it "displays a other_user's article update time" do
        within ".article-table" do
          expect(page).to have_content time_format other_article.updated_at
        end
      end

      it "doesn't display a '記事を書く' button" do
        expect(page).to have_no_link "記事を書く"
      end

      it "doesn't display a '編集' button" do
        expect(page).to have_no_link "編集"
      end

      it "doesn't display a '削除' button" do
        expect(page).to have_no_link "削除"
      end
    end

    describe "article show function" do
      before do
        visit article_path article
      end

      it "displays a '記事一覧' link" do
        within ".container-fluid" do
          expect(page).to have_link "記事一覧", href: articles_path
        end
      end

      it "displays an article's title as heading" do
        within "h1" do
          expect(page).to have_content article.title
        end
      end

      it "displays a link of article's author in the table" do
        within ".article-table" do
          expect(page).to have_link article.user.name, href: user_path(article.user)
        end
      end

      it "displays an article's create time" do
        within "table" do
          expect(page).to have_content time_format article.created_at
        end
      end

      it "displays an article's update time" do
        within ".article-table" do
          expect(page).to have_content time_format article.updated_at
        end
      end

      it "displays an article's text" do
        expect(page).to have_content article.text
      end

      it "doesn't display if twitter_announce executed" do
        expect(page).to have_no_content "実行済"
          expect(page).to have_no_content "未実行"
      end

      it "doesn't display a '編集' button" do
        expect(page).to have_no_link "編集"
      end

      it "doesn't display a '削除' button" do
        expect(page).to have_no_link "削除"
      end
    end
  end

  describe "additional function with a user's log-in" do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログインする'
    end

    describe "article index function" do
      before do
        visit articles_path
      end

      it "displays a '記事を書く' button" do
        within ".container-fluid" do
          expect(page).to have_link "記事を書く", href: new_article_path
        end
      end

      it "displays a '編集' button in table line of user's article" do
        within ".user-article" do
          expect(page).to have_link "編集", href: edit_article_path(article)
        end
      end

      it "displays a '削除' button in table line of user's article" do
        within ".user-article" do
          expect(page).to have_link "削除", href: article_path(article)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end

      it "doesn't display a '編集' button in the table line of other_user's article" do
        within ".other_user-article" do
          expect(page).to have_no_link "編集"
        end
      end

      it "doesn't display a '削除' button in the table line of other_user's article" do
        within ".other_user-article" do
          expect(page).to have_no_link "削除"
        end
      end
    end

    describe "article show function" do
      before do
        visit article_path article
      end

      it "displays '未実行' when the shown user's article wasn't tweeted for announce" do
        within ".article-table" do
          expect(page).to have_content "未実行"
        end
      end

      it "displays '実行済' when the shown user's article was tweeted for announce" do
        visit article_path tweeted_article
        within ".article-table" do
          expect(page).to have_content "実行済"
        end
      end

      it "displays a '編集' button" do
        expect(page).to have_link "編集", href: edit_article_path(article)
      end

      it "displays a '削除' button" do
        expect(page).to have_link "削除", href: article_path(article)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
      end

      context "visit other user's article show page" do
        before do
          visit article_path other_article
        end

        it "doesn't display if twitter_announce executed" do
          expect(page).to have_no_content "実行済"
          expect(page).to have_no_content "未実行"
        end

        it "doesn't display a '編集' button" do
          expect(page).to have_no_link "編集"
        end

        it "doesn't display a '削除' button" do
          expect(page).to have_no_link "削除"
        end
      end
    end

    describe "article new function" do
      before do
        visit new_article_path
      end

      it "displays a '記事一覧' link" do
        within ".container-fluid" do
          expect(page).to have_link "記事一覧", href: articles_path
        end
      end

      it "doesn't display any error messages" do
        expect(page).to have_no_selector "#error_explanation"
      end

      it "displays a '題名' form" do
        within ".form" do
          expect(page).to have_field "題名"
        end
      end

      it "displays a '概要' form" do
        within ".form" do
          expect(page).to have_field "概要"
        end
      end

      it "displays a '本文' form" do
        within ".form" do
          expect(page).to have_field "本文"
        end
      end

      it "displays a check box about tweet for announce" do
        within ".form" do
          expect(page).to have_unchecked_field("Twitterの専用アカウントによる告知機能を利用しますか？")
        end
      end

      it "displays a '投稿する' button" do
        within ".form" do
          expect(page).to have_button "投稿する"
        end
      end
    end

    describe "article create function" do
      let(:article_title) { "sample article" }
      let(:article_description) { "sample article description" }
      let(:article_text) { "It is a sample article" }
      let(:sample_article) { Article.find_by(title: article_title) }

      before do
        visit new_article_path
        fill_in "題名", with: article_title
        fill_in "概要", with: article_description
        fill_in "本文", with: article_text
        click_button "投稿する"
      end

      context "when all text box is filled in correctly" do
        it "redirects to the author's blog page" do
          expect(page).to have_current_path user_path(sample_article.user), ignore_query: true
        end

        it "displays flash message about success in posting article" do
          expect(page).to have_selector ".alert-success", text: "記事「#{sample_article.title}」を投稿しました。"
        end

        it "displays the posted article informaiton in the author's article table" do
          within ".article-table" do
            expect(page).to have_content sample_article.title
            expect(page).to have_content sample_article.description
            expect(page).to have_content time_format sample_article.updated_at
          end
        end

        context "when check box about tweet for announce is checked" do
          before do
            visit new_article_path
            fill_in "題名", with: article_title
            fill_in "概要", with: article_description
            fill_in "本文", with: article_text
            check "Twitterの専用アカウントによる告知機能を利用しますか？"
            click_button "投稿する"
          end

          it "displays flash message about success in posting article and tweeting for announce" do
            expect(page).to have_selector ".alert-success", text: "記事「#{sample_article.title}」を投稿し、Twitterで告知しました。"
          end
        end
      end

      context "when one or more text boxes are filled in incorrectly" do
        let(:article_title) { "" }

        it "displays erroor message about posting article" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays article_title, article_description and article_text in each text box which are filled in before pushing '投稿する'" do
          within ".form" do
            expect(page).to have_field "題名", with: article_title
            expect(page).to have_field "概要", with: article_description
            expect(page).to have_field "本文", with: article_text
          end
        end
      end
    end

    describe "article edit function" do
      before do
        visit edit_article_path article
      end

      it "displays a '記事一覧' link" do
        within ".container-fluid" do
          expect(page).to have_link "記事一覧", href: articles_path
        end
      end

      it "doesn't display any error messages" do
        expect(page).to have_no_selector "#error_explanation"
      end

      it "displays a '題名' form which is filled in" do
        within ".form" do
          expect(page).to have_field "題名", with: article.title
        end
      end

      it "displays a '概要' form which is filled in" do
        within ".form" do
          expect(page).to have_field "概要", with: article.description
        end
      end

      it "displays a '本文' form which is filled in" do
        within ".form" do
          expect(page).to have_field "本文", with: article.text
        end
      end

      it "displays a check box about tweet for announce" do
        within ".form" do
          expect(page).to have_unchecked_field("Twitterの専用アカウントによる告知機能を利用しますか？")
        end
      end

      it "displays a '更新する' button" do
        within ".form" do
          expect(page).to have_button "更新する"
        end
      end
    end

    describe "article update function" do
      let(:article_title) { article.title }
      let(:article_description) { article.description }
      let(:article_text) { article.text }

      before do
        visit edit_article_path article
        fill_in "題名", with: article_title
        fill_in "概要", with: article_description
        fill_in "本文", with: article_text
        click_button "更新する"
      end

      context "when all text box is filled in correctly" do
        it "redirects to the author's blog page" do
          expect(page).to have_current_path user_path(article.user), ignore_query: true
        end

        it "displays a flash message about success in updating article" do
          expect(page).to have_selector ".alert-success", text: "記事「#{article.title}」を編集しました。"
        end

        it "displays the updated article informaiton in the author's article table" do
          within ".article-table" do
            expect(page).to have_content article.title
            expect(page).to have_content article.description
            expect(page).to have_content time_format article.updated_at
          end
        end

        context "when check box about tweet for announce is checked" do
          before do
            visit edit_article_path article
            fill_in "題名", with: article_title
            fill_in "概要", with: article_description
            fill_in "本文", with: article_text
            check "Twitterの専用アカウントによる告知機能を利用しますか？"
            click_button "更新する"
          end

          it "displays flash message about success in updating article and tweeting for announce" do
            expect(page).to have_selector ".alert-success", text: "記事「#{article.title}」を編集し、Twitterで告知しました。"
          end
        end
      end

      context "when one or more text boxes are filled in incorrectly" do
        let(:article_title) { "" }

        it "displays erroor message about updating article" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays article_title, article_description and article_text in each text box which are filled in before pushing '更新する'" do
          within ".form" do
            expect(page).to have_field "題名", with: article_title
            expect(page).to have_field "概要", with: article_description
            expect(page).to have_field "本文", with: article_text
          end
        end
      end
    end

    describe "article destroy function" do
      before do
        visit article_path user.articles.first
      end

      context "push '削除' button and accept confirm" do
        before do
          accept_confirm do
            click_link "削除"
          end
        end

        it "redirects to the author's blog page" do
          expect(page).to have_current_path user_path(article.user), ignore_query: true
        end

        it "displays a flash message about success in deleting article" do
          expect(page).to have_selector ".alert-success", text: "記事「#{article.title}」を削除しました。"
        end

        it "doesn't display the deleted article's title in the author's article table" do
          expect(page).to have_no_selector ".article-table", text: article.title
        end
      end

      context "push '削除' button and dismiss confirm" do
        before do
          dismiss_confirm do
            click_link "削除"
          end
        end

        it "displays the article's title in the author's article table" do
          visit user_path article.user
          expect(page).to have_selector ".article-table", text: article.title
        end
      end
    end
  end

  describe "additional function with an admin_user's log-in" do
    before do
      visit login_path
      fill_in 'メールアドレス', with: admin_user.email
      fill_in 'パスワード', with: admin_user.password
      click_button 'ログインする'
    end

    describe "article index function" do
      before do
        visit articles_path
      end

      it "displays a '編集' button in table line of user's article" do
        within ".user-article" do
          expect(page).to have_link "編集", href: edit_article_path(article)
        end
      end

      it "displays a '削除' button in table line of user's article" do
        within ".user-article" do
          expect(page).to have_link "削除", href: article_path(article)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end

      it "displays a '編集' button in table line of other_user's article" do
        within ".other_user-article" do
          expect(page).to have_link "編集", href: edit_article_path(other_article)
        end
      end

      it "displays a '削除' button in table line of other_user's article" do
        within ".other_user-article" do
          expect(page).to have_link "削除", href: article_path(other_article)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end
    end

    describe "article show function" do
      before do
        visit article_path article
      end

      it "displays '未実行' when the shown user's article wasn't tweeted for announce" do
        within ".article-table" do
          expect(page).to have_content "未実行"
        end
      end

      it "displays '実行済' when the shown user's article was tweeted for announce" do
        visit article_path tweeted_article
        within ".article-table" do
          expect(page).to have_content "実行済"
        end
      end

      it "displays a '編集' button" do
        expect(page).to have_link "編集", href: edit_article_path(article)
      end

      it "displays a '削除' button" do
        expect(page).to have_link "削除", href: article_path(article)
        expect(page).to have_selector "a[data-method=delete]", text: "削除"
      end
    end
  end
end
