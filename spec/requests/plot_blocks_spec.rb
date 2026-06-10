require "rails_helper"

RSpec.describe "PlotBlocks", type: :request do
  let(:user) { create(:user) }
  # テスト用の作品（自分の作品）
  let(:creation) { create(:creation, user: user) }

  before do
    sign_in user
  end

  describe "POST /creations/:creation_id/plot_blocks" do
    context "自分の作品に対して" do
      it "プロットブロックを作成できる" do
        expect {
          post creation_plot_blocks_path(creation),
            params: { plot_block: { title: "テストブロック", content: "" } }
        }.to change(PlotBlock, :count).by(1)
      end

      it "タイトルが空のブロックは作成できない" do
        expect {
          post creation_plot_blocks_path(creation),
            params: { plot_block: { title: "", content: "" } }
        }.not_to change(PlotBlock, :count)
      end

      it "作成後はmemos_pathにリダイレクトされる" do
        post creation_plot_blocks_path(creation),
          params: { plot_block: { title: "テストブロック", content: "" } }
        expect(response).to redirect_to(memos_path(creation_id: creation.id))
      end
    end

    context "他のユーザーの作品に対して" do
      it "プロットブロックを作成できない" do
        other_user = create(:user)
        other_creation = create(:creation, user: other_user)
        expect {
          post creation_plot_blocks_path(other_creation),
            params: { plot_block: { title: "テストブロック", content: "" } }
        }.not_to change(PlotBlock, :count)
      end
    end
  end

  describe "DELETE /creations/:creation_id/plot_blocks/:id" do
    it "自分の作品のブロックを削除できる" do
      plot_block = create(:plot_block, creation: creation)
      expect {
        delete creation_plot_block_path(creation, plot_block)
      }.to change(PlotBlock, :count).by(-1)
    end

    it "削除後はmemos_pathにリダイレクトされる" do
      plot_block = create(:plot_block, creation: creation)
      delete creation_plot_block_path(creation, plot_block)
      expect(response).to redirect_to(memos_path(creation_id: creation.id))
    end

    it "他のユーザーの作品のブロックは削除できない" do
      other_user = create(:user)
      other_creation = create(:creation, user: other_user)
      other_plot_block = create(:plot_block, creation: other_creation)
      expect {
        delete creation_plot_block_path(other_creation, other_plot_block)
      }.not_to change(PlotBlock, :count)
    end
  end
end
