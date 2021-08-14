require 'rails_helper'

describe "article management system", type: :system do
  let(:user) { create(:user, name: "user") }
  let(:other_user) { create(:user, name: "other_user", email: "other_user@example.com") }
  let(:admin_user) { create(:user, email: "admin_user@example.com", admin: true) }
  let!(:article) { create(:article, user: user) }
  let(:with_description_article) { create(:article, description: "hello", user: user) }
  let(:blank_description_article) { create(:article, description: " ", user: user) }
  let(:no_description_article) { create(:article, description: nil, user: user) }
  let!(:other_article) { create(:article, title: "other_article's title",  user: other_user) }
  let(:tweeted_article) { create(:article, title: "tweet announce", text: "tweet announce", twitter_announce: true, user: user) }
  let!(:category) { create(:category, user: user, articles: [article]) }
  let!(:other_category) { create(:category, category_tag: "other category", user: user) }
  let!(:other_user_category) { create(:category, category_tag: "other user category", user: other_user) }

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
          expect(page).to have_content article.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a other_user's article update time" do
        within ".article-table" do
          expect(page).to have_content other_article.updated_at.strftime("%Y年%m月%d日-%H:%M")
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

      it "displays a link of article's author" do
        within ".article-info" do
          expect(page).to have_link article.user.name, href: user_path(article.user)
        end
      end

      it "displays a link of article's category" do
        within ".article-info" do
          article.categories.each do |category|
            expect(page).to have_link category.category_tag, href: category_path(category)
          end
        end
      end

      it "displays an article's create time" do
        within ".article-info" do
          expect(page).to have_content article.created_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays an article's update time" do
        within ".article-info" do
          expect(page).to have_content article.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays an article's text" do
        expect(page).to have_content "a" * 100
      end

      it "doesn't display a link of a category which isn't associated with the article" do
        expect(page).to have_no_link other_category.category_tag
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

      context "when article has description" do
        before do
          visit article_path with_description_article
        end

        it "displays description area" do
          within ".description-area" do
            expect(page).to have_content "概要"
            expect(page).to have_content with_description_article.description
          end
        end
      end

      context "when article doesn't have description" do
        before do
          visit article_path no_description_article
        end

        it "doesn't display description area" do
          expect(page).to have_no_selector ".description-area"
        end
      end

      context "when article has blank description" do
        before do
          visit article_path blank_description_article
        end

        it "doesn't display description area" do
          expect(page).to have_no_selector ".description-area"
        end
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
        within ".article-info" do
          expect(page).to have_content "未実行"
        end
      end

      it "displays '実行済' when the shown user's article was tweeted for announce" do
        visit article_path tweeted_article
        within ".article-info" do
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
          within ".field" do
            expect(page).to have_content "本文"
            expect(page).to have_selector "trix-toolbar"
            expect(page).to have_selector "trix-editor"
          end
        end
      end

      it "displays check boxes about article category" do
        within ".form" do
          expect(page).to have_unchecked_field category.category_tag
          expect(page).to have_unchecked_field other_category.category_tag
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

      it "doesn't display a check box about other user's category" do
        expect(page).to have_no_unchecked_field other_user_category.category_tag
      end
    end

    describe "article create function" do
      let(:article_title) { "new article" }
      let(:article_description) { "new article description" }
      let(:article_text) { "It is a new article" }
      let(:new_article) { Article.find_by(title: article_title) }

      context "when all text box is filled in correctly" do
        before do
          visit new_article_path
          fill_in "題名", with: article_title
          fill_in "概要", with: article_description
          fill_in_rich_text_area "本文", with: article_text
          click_button "投稿する"
        end

        it "redirects to the author's blog page" do
          expect(page).to have_current_path user_path(new_article.user), ignore_query: true
        end

        it "displays flash message about success in posting article" do
          expect(page).to have_selector ".alert-success", text: "記事「#{new_article.title}」を投稿しました。"
        end

        it "displays the posted article informaiton in the author's article table" do
          within ".article-table" do
            expect(page).to have_content new_article.title
            expect(page).to have_content new_article.description
            expect(page).to have_content new_article.updated_at.strftime("%Y年%m月%d日-%H:%M")
          end
        end

        context "when check box about article category is checked" do
          let(:article_title_2) { "new article 2" }
          let(:article_description_2) { "new article description 2" }
          let(:article_text_2) { "It is a new article 2" }
          let(:new_categorised_article) { Article.find_by(title: article_title_2) }

          before do
            visit new_article_path
            fill_in "題名", with: article_title_2
            fill_in "概要", with: article_description_2
            fill_in_rich_text_area "本文", with: article_text_2
            check other_category.category_tag
            click_button "投稿する"
          end

          it "displays a link of article's category on the article show page" do
            visit article_path new_categorised_article
            within ".article-info" do
              expect(page).to have_link other_category.category_tag, href: category_path(other_category)
            end
          end

          it "displays article informaitons on the category show page" do
            visit category_path other_category
            within ".article-table" do
              expect(page).to have_link new_categorised_article.title, href: article_path(new_categorised_article)
              expect(page).to have_link new_categorised_article.user.name, href: user_path(new_categorised_article.user)
              expect(page).to have_content new_categorised_article.updated_at.strftime("%Y年%m月%d日-%H:%M")
            end
          end
        end

        context "when check box about tweet for announce is checked" do
          let(:article_title_3) { "new article 3" }
          let(:article_description_3) { "new article description 3" }
          let(:article_text_3) { "It is a new article 3" }
          let(:new_tweeted_article) { Article.find_by(title: article_title_3) }

          before do
            visit new_article_path
            fill_in "題名", with: article_title_3
            fill_in "概要", with: article_description_3
            fill_in_rich_text_area "本文", with: article_text_3
            check "Twitterの専用アカウントによる告知機能を利用しますか？"
            click_button "投稿する"
          end

          it "displays flash message about success in posting article and tweeting for announce" do
            expect(page).to have_selector ".alert-success", text: "記事「#{new_tweeted_article.title}」を投稿し、Twitterで告知しました。"
          end
        end

        context "when a images is attached in rich_text_area" do
          let(:article_title_4) { "new article 4" }
          let(:article_description_4) { "new article description 4" }
          let(:article_text_4) { "It is a new article 4" }
          let(:image_attached_article) { Article.find_by(title: article_title_4) }

          before do
            visit new_article_path
            fill_in "題名", with: article_title_4
            fill_in "概要", with: article_description_4
            fill_in_rich_text_area "本文", with: article_text_4
            page.attach_file("#{Rails.root}/app/assets/images/test.jpg") do
              page.find('.trix-button--icon-attach').click
            end
            click_button "投稿する"
          end

          it "displays a attached image on the article show page" do
            visit article_path image_attached_article
            within ".trix-content" do
              expect(page).to have_selector("img[src$='test.jpg']")
            end
          end
        end
      end

      context "when one or more text boxes are filled in incorrectly" do
        let(:article_title) { "" }

        before do
          visit new_article_path
          fill_in "題名", with: article_title
          fill_in "概要", with: article_description
          fill_in_rich_text_area "本文", with: article_text
          click_button "投稿する"
        end

        it "displays error message about posting article" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays article_title, article_description and article_text in each text box which are filled in before pushing '投稿する'" do
          within ".form" do
            expect(page).to have_field "題名", with: article_title
            expect(page).to have_field "概要", with: article_description
            expect(page).to have_selector "trix-editor", text: article_text
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
          within ".field" do
            expect(page).to have_content "本文"
            expect(page).to have_selector "trix-toolbar"
            expect(page).to have_selector "trix-editor", text: "a" * 100
          end
        end
      end

      it "displays check boxes about article category" do
        within ".form" do
          expect(page).to have_checked_field category.category_tag
          expect(page).to have_unchecked_field other_category.category_tag
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

      it "doesn't display a check box about other user's category" do
        expect(page).to have_no_checked_field other_user_category.category_tag
      end
    end

    describe "article update function" do
      let(:article_title) { article.title }
      let(:article_description) { article.description }
      let(:article_text) { article.text }
      let(:article_category) { article.category_ids }

      before do
        visit edit_article_path article
        fill_in "題名", with: article_title
        fill_in "概要", with: article_description
        fill_in_rich_text_area "本文", with: article_text
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
            expect(page).to have_content article.updated_at.strftime("%Y年%m月%d日-%H:%M")
          end
        end

        context "when check box about article category is checked" do
          before do
            visit edit_article_path article
            fill_in "題名", with: article_title
            fill_in "概要", with: article_description
            fill_in_rich_text_area "本文", with: article_text
            check other_category.category_tag
            click_button "更新する"
          end

          it "displays a link of article's category on the article show page" do
            visit article_path article
            within ".article-info" do
              expect(page).to have_link other_category.category_tag, href: category_path(other_category)
            end
          end

          it "displays article informaitons on the category show page" do
            visit category_path other_category
            within ".article-table" do
              expect(page).to have_link article.title, href: article_path(article)
              expect(page).to have_link article.user.name, href: user_path(article.user)
              expect(page).to have_content article.updated_at.strftime("%Y年%m月%d日-%H:%M")
            end
          end
        end

        context "when check box about tweet for announce is checked" do
          before do
            visit edit_article_path article
            fill_in "題名", with: article_title
            fill_in "概要", with: article_description
            fill_in_rich_text_area "本文", with: article_text
            check "Twitterの専用アカウントによる告知機能を利用しますか？"
            click_button "更新する"
          end

          it "displays flash message about success in updating article and tweeting for announce" do
            expect(page).to have_selector ".alert-success", text: "記事「#{article.title}」を編集し、Twitterで告知しました。"
          end
        end

        context "when a images is attached in rich_text_area" do
          before do
            visit edit_article_path article
            fill_in "題名", with: article_title
            fill_in "概要", with: article_description
            fill_in_rich_text_area "本文", with: article_text
            page.attach_file("#{Rails.root}/app/assets/images/test.jpg") do
              page.find('.trix-button--icon-attach').click
            end
            click_button "更新する"
          end

          it "displays a attached image on the article show page" do
            visit article_path article
            within ".trix-content" do
              expect(page).to have_selector("img[src$='test.jpg']")
            end
          end
        end
      end

      context "when one or more text boxes are filled in incorrectly" do
        let(:article_title) { "" }

        it "displays error message about updating article" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays article_title, article_description and article_text in each text box which are filled in before pushing '更新する'" do
          within ".form" do
            expect(page).to have_field "題名", with: article_title
            expect(page).to have_field "概要", with: article_description
            expect(page).to have_selector "trix-editor", text: "a" * 100
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
        within ".article-info" do
          expect(page).to have_content "未実行"
        end
      end

      it "displays '実行済' when the shown user's article was tweeted for announce" do
        visit article_path tweeted_article
        within ".article-info" do
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
