require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category, user: user) }

  describe "GET /categories/:id" do
    it "returns http success with user's log-in" do
      log_in_as user
      get category_path category
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /categories/:id/edit" do
    it "returns http success with user's log-in" do
      log_in_as user
      get edit_category_path category
      expect(response).to have_http_status(:success)
    end

    it "doesn't return http success without user's log-in" do
      get edit_category_path category
      expect(response).to_not have_http_status(:success)
    end
  end
end
