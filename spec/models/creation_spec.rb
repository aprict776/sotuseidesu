require "rails_helper"

RSpec.describe Creation, type: :model do
  describe "バリデーション" do
    it "titleとuserがあれば有効である" do
      creation = build(:creation)
      expect(creation).to be_valid
    end

    it "titleがなければ無効である" do
      creation = build(:creation, title: "")
      expect(creation).not_to be_valid
    end

    it "titleが134文字以内であれば有効である" do
      creation = build(:creation, title: "a" * 134)
      expect(creation).to be_valid
    end

    it "titleが135文字以上であれば無効である" do
      creation = build(:creation, title: "a" * 135)
      expect(creation).not_to be_valid
    end

    it "userがなければ無効である" do
      creation = build(:creation, user: nil)
      expect(creation).not_to be_valid
    end
  end
end
