require "rails_helper"

RSpec.describe "Creations", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "POST /creations" do
    it "作品を作成できる" do
      expect {
        post creations_path, params: { creation: { title: "テスト作品" } }
      }.to change(Creation, :count).by(1)
    end

    it "タイトルが空の場合は作成できない" do
      expect {
        post creations_path, params: { creation: { title: "" } }
      }.not_to change(Creation, :count)
    end

    it "タイトルが135文字以上の場合は作成できない" do
      expect {
        post creations_path, params: { creation: { title: "a" * 135 } }
      }.not_to change(Creation, :count)
    end
  end

  describe "DELETE /creations/:id" do
    it "自分の作品を削除できる" do
      creation = create(:creation, user: user)
      expect {
        delete creation_path(creation)
      }.to change(Creation, :count).by(-1)
    end

    it "他のユーザーの作品は削除できない" do
      other_user = create(:user)
      other_creation = create(:creation, user: other_user)
      expect {
        delete creation_path(other_creation)
      }.not_to change(Creation, :count)
    end
  end
end
