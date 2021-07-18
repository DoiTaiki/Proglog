require 'rails_helper'

describe "user management system", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:admin_user) { create(:user, admin: true) }
  let!(:article) { create(:article, user: user) }
  let!(:other_article) { create(:article, title: "other_article's title",  user: other_user) }

  describe "basic function" do
    describe "user index function" do
      before do
        visit users_path
      end

      it "displays a link of user's name" do
        within ".user-table" do
          expect(page).to have_link user.name, href: user_path(user)
        end
      end

      it "displays a link of other_user's name" do
        within ".user-table" do
          expect(page).to have_link other_user.name, href: user_path(other_user)
        end
      end

      it "displays a link of admin_user's name" do
        within ".user-table" do
          expect(page).to have_link admin_user.name, href: user_path(admin_user)
        end
      end

      it "displays a user's profile create time" do
        within ".user-table" do
          expect(page).to have_content user.created_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a other_user's profile create time" do
        within ".user-table" do
          expect(page).to have_content other_user.created_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a admin_user's profile create time" do
        within ".user-table" do
          expect(page).to have_content admin_user.created_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a user's profile update time" do
        within ".user-table" do
          expect(page).to have_content user.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a other_user's profile update time" do
        within ".user-table" do
          expect(page).to have_content other_user.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a admin_user's profile update time" do
        within ".user-table" do
          expect(page).to have_content admin_user.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "doesn't display a user's email" do
        within ".user-table" do
          expect(page).to have_no_content user.email
        end
      end

      it "doesn't display a other_user's email" do
        within ".user-table" do
          expect(page).to have_no_content other_user.email
        end
      end

      it "doesn't display a admin_user's email" do
        within ".user-table" do
          expect(page).to have_no_content admin_user.email
        end
      end

      it "doesn't display which user has admin authority" do
        within ".user-table" do
          expect(page).to have_no_content "あり"
          expect(page).to have_no_content "なし"
        end
      end

      it "displays a '新規登録' button" do
        within ".container-fluid" do
          expect(page).to have_link "新規登録", href: new_user_path
        end
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
        visit user_path user
      end

      it "displays a '投稿者一覧' link" do
        within ".container-fluid" do
          expect(page).to have_link "投稿者一覧", href: users_path
        end
      end

      it "displays a blog's name as heading" do
        within "h1" do
          expect(page).to have_content user.blog_name
        end
      end

      it "displays a user's id in the profile" do
        within ".user-profile" do
          expect(page).to have_content user.id
        end
      end

      it "displays a user's name in the profile" do
        within ".user-profile" do
          expect(page).to have_content user.name
        end
      end

      it "displays a user's profile in the profile" do
        within ".user-profile" do
          expect(page).to have_content user.profile
        end
      end

      it "displays a user's account create time in the profile" do
        within ".user-profile" do
          expect(page).to have_content user.created_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "displays a user's profile update time in the profile" do
        within ".user-profile" do
          expect(page).to have_content user.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "doesn't display a user's email in the profile" do
        within ".user-profile" do
          expect(page).to have_no_content user.email
        end
      end

      it "doesn't display if user has admin authority in the profile" do
        within ".user-profile" do
          expect(page).to have_no_content "あり"
          expect(page).to have_no_content "なし"
        end
      end

      it "doesn't display a '編集' button in the profile" do
        within ".user-profile" do
          expect(page).to have_no_link "編集"
        end
      end

      it "doesn't display a '削除' button in the profile" do
        within ".user-profile" do
          expect(page).to have_no_link "削除"
        end
      end

      it "displays an article's title in the table" do
        within ".article-table" do
          expect(page).to have_link article.title
        end
      end

      it "displays an article's author in the table" do
        within ".article-table" do
          expect(page).to have_content article.user.name
        end
      end

      it "displays an article's update time" do
        within ".article-table" do
          expect(page).to have_content article.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "doesn't display a '編集' button" do
        within ".article-table" do
          expect(page).to have_no_link "編集"
        end
      end

      it "doesn't display a '削除' button" do
        within ".article-table" do
          expect(page).to have_no_link "削除"
        end
      end
    end

    describe "user new function" do
      before do
        visit new_user_path
      end

      it "displays '投稿者一覧' link" do
        within ".container-fluid" do
          expect(page).to have_link "投稿者一覧", href: users_path
        end
      end

      it "doesn't display any error messages" do
        expect(page).to have_no_selector "#error_explanation"
      end

      it "displays a '投稿者名' form" do
        within ".user-form" do
          expect(page).to have_field "投稿者名"
        end
      end

      it "displays a 'メールアドレス' form" do
        within ".user-form" do
          expect(page).to have_field "メールアドレス"
        end
      end

      it "displays a 'ブログ名' form" do
        within ".user-form" do
          expect(page).to have_field "ブログ名"
        end
      end

      it "displays a '自己紹介' form" do
        within ".user-form" do
          expect(page).to have_field "自己紹介"
        end
      end

      it "displays a 'パスワード' form" do
        within ".user-form" do
          expect(page).to have_field "パスワード"
        end
      end

      it "displays a 'パスワード(確認)' form" do
        within ".user-form" do
          expect(page).to have_field "パスワード(確認)"
        end
      end

      it "displays a '登録する' button" do
        within ".user-form" do
          expect(page).to have_button "登録する"
        end
      end
    end

    describe "user create function" do
      let(:user_name) { "sample user" }
      let(:user_email) { "sample_user@example.com" }
      let(:user_blog_name) { "SampleUserBlog" }
      let(:user_profile) { "It is a test sample." }
      let(:user_password) { "password" }
      let(:user_password_confirmation) { "password" }
      let(:new_user) { User.find_by(email: user_email) }

      before do
        visit new_user_path
        fill_in "投稿者名", with: user_name
        fill_in "メールアドレス", with: user_email
        fill_in "ブログ名", with: user_blog_name
        fill_in "自己紹介", with: user_profile
        fill_in "パスワード", with: user_password
        fill_in "パスワード(確認)", with: user_password_confirmation
        click_button "登録する"
      end

      context "when all text box is filled in correctly" do
        it "redirects to new user's blog page" do
          expect(page).to have_current_path user_path(new_user), ignore_query: true
        end

        it "displays flash message about success in registering user" do
          expect(page).to have_selector ".alert-success", text: "ユーザー「#{new_user.name}」を登録しました。"
        end
      end

      context "when one or more text boxes are filled in incorrectly" do
        let(:user_email) { "" }

        it "displays erroor message about registering user" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays all parameter except password in each text box which are filled in before pushing '登録する'" do
          within ".user-form" do
            expect(page).to have_field "投稿者名", with: user_name
            expect(page).to have_field "メールアドレス", with: user_email
            expect(page).to have_field "ブログ名", with: user_blog_name
            expect(page).to have_field "自己紹介", with: user_profile
          end
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

    describe "user index function" do
      before do
        visit users_path
      end

      it "doesn't display a '新規登録' link" do
        within ".container-fluid" do
          expect(page).to have_no_link "新規登録", href: new_user_path
        end
      end
    end

    describe "article show function" do
      before do
        visit user_path user
      end

      it "displays user's email" do
        within ".user-profile" do
          expect(page).to have_content user.email
        end
      end

      it "displays a '編集' button" do
        within ".user-profile" do
          expect(page).to have_link "編集", href: edit_user_path(user)
        end
      end

      it "displays a '削除' button" do
        within ".user-profile" do
          expect(page).to have_link "削除", href: user_path(user)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end

      it "displays a '記事を書く' button" do
        within ".container-fluid" do
          expect(page).to have_link "記事を書く", href: new_article_path
        end
      end

      context "visit other user's blog page" do
        before do
          visit user_path other_user
        end

        it "doesn't display other_user's email" do
          expect(page).to have_no_content other_user.email
        end

        it "doesn't display a '編集' button" do
          expect(page).to have_no_link "編集"
        end

        it "doesn't display a '削除' button" do
          expect(page).to have_no_link "削除"
        end

        it "doesn't display a '記事を書く' button" do
          within ".container-fluid" do
            expect(page).to have_no_link "記事を書く"
          end
        end
      end
    end

    describe "article edit function" do
      before do
        visit edit_user_path user
      end

      it "displays a '投稿者一覧' link" do
        within ".container-fluid" do
          expect(page).to have_link "投稿者一覧", href: users_path
        end
      end

      it "doesn't display any error messages" do
        expect(page).to have_no_selector "#error_explanation"
      end

      it "displays a '投稿者名' form which is filled in" do
        within ".user-form" do
          expect(page).to have_field "投稿者名", with: user.name
        end
      end

      it "displays a 'メールアドレス' form which is filled in" do
        within ".user-form" do
          expect(page).to have_field "メールアドレス", with: user.email
        end
      end

      it "displays a 'ブログ名' form which is filled in" do
        within ".user-form" do
          expect(page).to have_field "ブログ名", with: user.blog_name
        end
      end

      it "displays a '自己紹介' form which is filled in" do
        within ".user-form" do
          expect(page).to have_field "自己紹介", with: user.profile
        end
      end

      it "displays a 'パスワード' form" do
        within ".user-form" do
          expect(page).to have_field "パスワード"
        end
      end

      it "displays a 'パスワード(確認)' form" do
        within ".user-form" do
          expect(page).to have_field "パスワード(確認)"
        end
      end

      it "displays a '更新する' button" do
        within ".user-form" do
          expect(page).to have_button "更新する"
        end
      end
    end

    describe "user update function" do
      let(:user_name) { "updated sample user" }
      let(:user_email) { "updated_sample_user@example.com" }
      let(:user_blog_name) { "UpdatedSampleUserBlog" }
      let(:user_profile) { "It is a updated test sample." }
      let(:user_password) { "updated" }
      let(:user_password_confirmation) { "updated" }

      before do
        visit edit_user_path user
        fill_in "投稿者名", with: user_name
        fill_in "メールアドレス", with: user_email
        fill_in "ブログ名", with: user_blog_name
        fill_in "自己紹介", with: user_profile
        fill_in "パスワード", with: user_password
        fill_in "パスワード(確認)", with: user_password_confirmation
        click_button "更新する"
      end

      context "when all text box is filled in correctly" do
        it "redirects to user's blog page" do
          expect(page).to have_current_path user_path(user), ignore_query: true
        end

        it "displays flash message about success in updating user" do
          expect(page).to have_selector ".alert-success", text: "ユーザー「#{user_name}」を更新しました。"
        end
      end

      context "when one or more text boxes are filled in incorrectly" do
        let(:user_email) { "" }

        it "displays erroor message about updating user" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays all parameter except password in each text box which are filled in before pushing '更新する'" do
          within ".user-form" do
            expect(page).to have_field "投稿者名", with: user_name
            expect(page).to have_field "メールアドレス", with: user_email
            expect(page).to have_field "ブログ名", with: user_blog_name
            expect(page).to have_field "自己紹介", with: user_profile
          end
        end
      end
    end

    describe "article destroy function" do
      before do
        visit user_path user
      end

      context "push '削除' button and accept confirm" do
        before do
          wait_for_css_appear(".btn-danger")
          accept_confirm do
            within ".user-profile" do
              click_link "削除"
            end
          end
        end

        it "redirects to user index page" do
          expect(page).to have_current_path users_path, ignore_query: true
        end

        it "displays a flash message about success in deleting user" do
          expect(page).to have_selector ".alert-success", text: "ユーザー「#{user.name}」を削除しました。"
        end

        it "doesn't display the deleted user's name in the user table" do
          expect(page).to have_no_selector ".user-table", text: user.name
        end
      end

      context "push '削除' button and dismiss confirm" do
        before do
          wait_for_css_appear(".btn-danger")
          dismiss_confirm do
            within ".user-profile" do
              click_link "削除"
            end
          end
        end

        it "displays the user's name in the user table" do
          visit users_path
          expect(page).to have_selector ".user-table", text: user.name
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

    describe "user index function" do
      before do
        visit users_path
      end

      it "displays a '編集' button in table line of user" do
        within ".#{user.name}-link" do
          expect(page).to have_link "編集", href: edit_user_path(user)
        end
      end

      it "displays '削除' buttons for each of users" do
        within ".#{user.name}-link" do
          expect(page).to have_link "削除", href: user_path(user)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end

      it "displays a '編集' button in table line of other user" do
        within ".#{other_user.name}-link" do
          expect(page).to have_link "編集", href: edit_user_path(other_user)
        end
      end

      it "displays '削除' buttons for each of other_user" do
        within ".#{other_user.name}-link" do
          expect(page).to have_link "削除", href: user_path(other_user)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end
    end

    describe "user show function" do
      before do
        visit user_path user
      end

      it "displays user's email" do
        within ".user-profile" do
          expect(page).to have_content user.email
        end
      end

      it "displays a '編集' button" do
        within ".user-profile" do
          expect(page).to have_link "編集", href: edit_user_path(user)
        end
      end

      it "displays a '削除' button" do
        within ".user-profile" do
          expect(page).to have_link "削除", href: user_path(user)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end

      it "displays 'なし' in admin authority culumn" do
        within ".user-profile" do
          expect(page).to have_content "なし"
        end
      end

      context "when admin user visit a admin user's blog page" do
        before do
          visit user_path admin_user
        end

        it "displays 'あり' in admin authority culumn" do
          within ".user-profile" do
            expect(page).to have_content "あり"
          end
        end
      end
    end
  end
end
