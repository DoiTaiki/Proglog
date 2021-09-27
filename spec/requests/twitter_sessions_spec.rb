require 'rails_helper'

RSpec.describe "TwitterSessions", type: :request do
  let(:user) { create(:user, :member) }

  describe "GET /new_link_account" do
    it "returns http success" do
      get new_link_account_path
      expect(response).to have_http_status(:success)
    end
  end
end
