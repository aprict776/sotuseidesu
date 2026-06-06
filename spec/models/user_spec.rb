require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "name、email、passwordがあれば有効である" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "nameがなければ無効である" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
    end

    it "emailがなければ無効である" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "emailが重複していれば無効である" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end

    it "passwordがなければ無効である" do
      user = build(:user, password: "")
      expect(user).not_to be_valid
    end
  end
end
