require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let(:user) { create(:user) }
  let(:article) { create(:article, user: user) }

  describe "GET /articles/new" do
    it "returns http success with user's log-in" do
      log_in_as user
      get new_article_path
      expect(response).to have_http_status(:success)
    end

    it "doesn't return http success without user's log-in" do
      get new_article_path
      expect(response).to_not have_http_status(:success)
    end
  end

  describe "GET /articles/:id/edit" do
    it "returns http success with user's log-in" do
      log_in_as user
      get edit_article_path article
      expect(response).to have_http_status(:success)
    end

    it "doesn't return http success without user's log-in" do
      get edit_article_path article
      expect(response).to_not have_http_status(:success)
    end
  end

  describe "GET /articles/:id" do
    it "returns http success" do
      get article_path article
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /articles" do
    it "returns http success" do
      get articles_path
      expect(response).to have_http_status(:success)
    end
  end
end
