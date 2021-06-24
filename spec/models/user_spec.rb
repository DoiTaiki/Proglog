require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it "has a valid user" do
    expect(build(:user)).to be_valid
  end
end
