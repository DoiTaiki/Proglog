require 'rails_helper'

describe "category management system", type: :system do
  let(:login_user) { create(:user, :member) }
  let(:other_user) { create(:user, name: "other user") }
  let!(:category) { create(:category, user: login_user) }
  let(:other_user_category) { create(:category, user: other_user) }
  let!(:categorised_article) { create(:article, user: login_user, categories: [category]) }
  let!(:other_user_categorised_article) { create(:article, title: "other_user_categorised_article", user: other_user, categories: [other_user_category]) }
  let!(:no_categorised_article) { create(:article, title: "no_categorised_article", user: login_user) }

  describe "basic function" do
    describe "category show function" do
      before do
        visit category_path category
      end

      it "displays a category's title as heading" do
        within "h3" do
          expect(page).to have_content category.category_tag
        end
      end

      it "displays a link of categorised_article title" do
        within ".article-table" do
          expect(page).to have_link categorised_article.title, href: article_path(categorised_article)
        end
      end

      it "displays a link of user's name" do
        within ".article-table" do
          expect(page).to have_link categorised_article.user.name, href: user_path(categorised_article.user)
        end
      end

      it "displays a categorised_article update time" do
        within ".article-table" do
          expect(page).to have_content categorised_article.updated_at.strftime("%Y年%m月%d日-%H:%M")
        end
      end

      it "doesn't display a link of other user's category article title" do
        expect(page).to have_no_link other_user_categorised_article.title
      end

      it "doesn't display a link of other user's name" do
        expect(page).to have_no_link other_user_categorised_article.user.name
      end

      it "doesn't display a link of no categorised article title" do
        expect(page).to have_no_link no_categorised_article.title
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
  end

  describe "additional function with a user's log-in" do
    before do
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

    describe "category show function" do
      before do
        visit category_path category
      end

      it "displays a '記事を書く' button" do
        within ".container-fluid" do
          expect(page).to have_link "記事を書く", href: new_article_path
        end
      end

      it "displays a '編集' button in table line of user's article" do
        within ".#{categorised_article.user.name}-article" do
          expect(page).to have_link "編集", href: edit_article_path(categorised_article)
        end
      end

      it "displays a '削除' button in table line of user's article" do
        within ".#{categorised_article.user.name}-article" do
          expect(page).to have_link "削除", href: article_path(categorised_article)
          expect(page).to have_selector "a[data-method=delete]", text: "削除"
        end
      end
    end

    describe "category create function" do
      let(:category_category_tag) { "sample category" }
      let(:sample_category) { Category.find_by(category_tag: category_category_tag) }

      before do
        click_button "#{login_user.blog_name}のカテゴリー"
        fill_in "カテゴリー名", with: category_category_tag
        click_button "追加"
      end

      context "when all text box is filled in correctly" do
        it "displays flash message about success in adding category" do
          expect(page).to have_selector ".alert-success", text: "カテゴリー「#{category_category_tag}」を登録しました。"
        end

        it "displays the added category in the category's dropdown on navbar" do
          click_button "#{login_user.blog_name}のカテゴリー"
          within "li.nav-item.dropdown" do
            expect(page).to have_content sample_category.category_tag
          end
        end
      end

      context "when category_tag's text box isn't filled in" do
        let(:category_category_tag) { "" }

        it "displays flash message about failure in adding category" do
          expect(page).to have_selector ".alert-danger", text: "カテゴリー名を入力してください。"
        end
      end

      context "when category_tag's text box is filled in　with too long string" do
        let(:category_category_tag) { "a" * 31 }

        it "displays flash message about failure in adding category" do
          expect(page).to have_selector ".alert-danger", text: "カテゴリー名は30文字以内で入力してください。"
        end
      end
    end

    describe "category edit function" do
      before do
        visit edit_category_path category
      end

      it "doesn't display any error messages" do
        expect(page).to have_no_selector "#error_explanation"
      end

      it "displays a 'カテゴリー名' form which is filled in" do
        within ".category-form" do
          expect(page).to have_field "カテゴリー名", with: category.category_tag
        end
      end

      it "displays a '更新する' button" do
        within ".category-form" do
          expect(page).to have_button "更新する"
        end
      end
    end

    describe "category update function" do
      let(:edited_category_category_tag) { "edited category" }
      let(:edited_category) { Category.find_by(category_tag: edited_category_category_tag) }

      before do
        visit edit_category_path category
        fill_in "カテゴリー名", with: edited_category_category_tag
        click_button "更新する"
      end

      context "when all text box is filled in correctly" do
        it "displays flash message about success in adding category" do
          expect(page).to have_selector ".alert-success", text: "カテゴリー「#{edited_category_category_tag}」を更新しました。"
        end

        it "displays the added category in the category's dropdown on navbar" do
          click_button "#{login_user.blog_name}のカテゴリー"
          within "li.nav-item.dropdown" do
            expect(page).to have_content edited_category.category_tag
          end
        end
      end

      context "when category_tag's text box isn't filled in" do
        let(:edited_category_category_tag) { "" }

        it "displays error message about updating category" do
          expect(page).to have_selector "#error_explanation"
        end

        it "displays category_tag in the text box which are filled in before pushing '更新する'" do
          within ".category-form" do
            expect(page).to have_field "カテゴリー名", with: edited_category_category_tag
          end
        end
      end
    end

    describe "article destroy function" do
      before do
        click_button "#{login_user.blog_name}のカテゴリー"
      end

      context "push '削除' button and accept confirm" do
        before do
          within ".category-#{category.id}" do
            accept_confirm do
              click_link "削除"
            end
          end
        end

        it "redirects to the user's blog page" do
          expect(page).to have_current_path user_path(category.user), ignore_query: true
        end

        it "displays a flash message about success in deleting category" do
          expect(page).to have_selector ".alert-success", text: "カテゴリー「#{category.category_tag}」を削除しました。"
        end

        it "doesn't display the deleted category's category_tag in the category dropdown" do
          expect(page).to have_no_selector "li.nav-item.dropdown", text: category.category_tag
        end
      end

      context "push '削除' button and dismiss confirm" do
        before do
          within ".category-#{category.id}" do
            dismiss_confirm do
              click_link "削除"
            end
          end
        end

        it "displays the category's category_tag in the category dropdown" do
          click_button "#{login_user.blog_name}のカテゴリー"
          expect(page).to have_selector "li.nav-item.dropdown", text: category.category_tag
        end
      end
    end
  end
end
