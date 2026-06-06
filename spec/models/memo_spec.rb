require "rails_helper"

RSpec.describe Memo, type: :model do
  describe "バリデーション" do
    it "contentとuserがあれば有効である" do
      memo = build(:memo)
      expect(memo).to be_valid
    end

    it "contentがなければ無効である" do
      memo = build(:memo, content: "")
      expect(memo).not_to be_valid
    end

    it "userがなければ無効である" do
      memo = build(:memo, user: nil)
      expect(memo).not_to be_valid
    end
  end
end