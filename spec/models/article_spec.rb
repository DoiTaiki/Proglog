require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { create(:user) }

  it "has a valid article" do
    expect(build(:article, user: user)).to be_valid
  end
end
