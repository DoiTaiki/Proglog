require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }

  describe "GET /users/new" do
    it "returns http success" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/:id/edit" do
    it "returns http success to get own account's edit page" do
      log_in_as user
      get edit_user_path user
      expect(response).to have_http_status(:success)
    end

    it "doesn't return http success to get other user account's edit page" do
      log_in_as other_user
      get edit_user_path user
      expect(response).to_not have_http_status(:success)
    end

    it "returns http success to get other user account's edit page by admin user" do
      log_in_as admin_user
      get edit_user_path user
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/:id" do
    it "returns http success" do
      get user_path user
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users" do
    it "returns http success" do
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

end
