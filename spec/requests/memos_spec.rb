require "rails_helper"

RSpec.describe "Memos", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /memos" do
    it "正常にレスポンスを返す" do
      get memos_path
      expect(response).to have_http_status(:ok)
    end

    it "自分のメモが表示される" do
      memo = create(:memo, user: user)
      get memos_path
      expect(response.body).to include(memo.content)
    end

    it "他のユーザーのメモは表示されない" do
      other_user = create(:user)
      other_memo = create(:memo, user: other_user)
      get memos_path
      expect(response.body).not_to include(other_memo.content)
    end
  end

  describe "POST /memos" do
    it "メモを作成できる" do
      expect {
        post memos_path, params: { memo: { content: "テストメモ" } }
      }.to change(Memo, :count).by(1)
    end

    it "空のメモは作成できない" do
      expect {
        post memos_path, params: { memo: { content: "" } }
      }.not_to change(Memo, :count)
    end
  end

  describe "DELETE /memos/:id" do
    it "自分のメモを削除できる" do
      memo = create(:memo, user: user)
      expect {
        delete memo_path(memo)
      }.to change(Memo, :count).by(-1)
    end

    it "他のユーザーのメモは削除できない" do
      other_user = create(:user)
      other_memo = create(:memo, user: other_user)
      expect {
        delete memo_path(other_memo)
      }.not_to change(Memo, :count)
    end
  end

  describe "GET /memos/:id/edit" do
    it "自分のメモの編集画面を表示できる" do
      memo = create(:memo, user: user)
      get edit_memo_path(memo)
      expect(response).to have_http_status(:ok)
    end

    it "他のユーザーのメモの編集画面は表示できない" do
      other_user = create(:user)
      other_memo = create(:memo, user: other_user)
      get edit_memo_path(other_memo)
      expect(response).not_to have_http_status(:ok)
    end
  end

  describe "PATCH /memos/:id" do
    it "自分のメモを更新できる" do
      memo = create(:memo, user: user)
      patch memo_path(memo), params: { memo: { content: "更新後のメモ" } }
      expect(memo.reload.content).to eq "更新後のメモ"
    end

    it "空のメモには更新できない" do
      memo = create(:memo, user: user)
      patch memo_path(memo), params: { memo: { content: "" } }
      expect(memo.reload.content).not_to eq ""
    end

    it "他のユーザーのメモは更新できない" do
      other_user = create(:user)
      other_memo = create(:memo, user: other_user)
      patch memo_path(other_memo), params: { memo: { content: "更新後のメモ" } }
      expect(other_memo.reload.content).not_to eq "更新後のメモ"
    end
  end
end
end