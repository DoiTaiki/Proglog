require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /new" do
    it "returns http success" do
      get new_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_admin_user_path user
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get admin_user_path user
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

end
