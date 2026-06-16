require "rails_helper"

RSpec.describe "PlotBlocks", type: :request do
  let(:user) { create(:user) }
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

      it "HTMLリクエストの場合はmemos_pathにリダイレクトされる" do
        post creation_plot_blocks_path(creation),
          params: { plot_block: { title: "テストブロック", content: "" } },
          headers: { "Accept" => "text/html" }
        expect(response).to redirect_to(memos_path(creation_id: creation.id))
      end

      it "Turbo Streamリクエストの場合はturbo_streamを返す" do
        post creation_plot_blocks_path(creation),
          params: { plot_block: { title: "テストブロック", content: "" } },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
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

  # ↓ describeブロックが丸ごと消えていたので復元
  it "自分の作品のブロックを削除できる" do
  plot_block = create(:plot_block, creation: creation)
  puts "current user id: #{user.id}"
  puts "creation user_id: #{creation.reload.user_id}"
  puts "plot_block id: #{plot_block.id}"
  puts "creation id: #{creation.id}"
  delete creation_plot_block_path(creation, plot_block)
  puts "status: #{response.status}"
  end

    it "HTMLリクエストの場合はmemos_pathにリダイレクトされる" do
      plot_block = create(:plot_block, creation: creation)
      delete creation_plot_block_path(creation, plot_block),
        headers: { "Accept" => "text/html" }
      expect(response).to redirect_to(memos_path(creation_id: creation.id))
    end

    it "Turbo Streamリクエストの場合はturbo_streamを返す" do
      plot_block = create(:plot_block, creation: creation)
      delete creation_plot_block_path(creation, plot_block),
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
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

  describe "POST /creations/:creation_id/plot_blocks/from_memo" do
    let(:memo) { create(:memo, user: user) }

    context "自分のメモから" do
      it "プロットブロックを作成できる" do
        expect {
          post from_memo_creation_plot_blocks_path(creation),
            params: { memo_id: memo.id }
        }.to change(PlotBlock, :count).by(1)
      end

      it "メモの内容がブロックにコピーされる" do
        post from_memo_creation_plot_blocks_path(creation),
          params: { memo_id: memo.id }
        expect(PlotBlock.last.content).to eq memo.content
      end

      it "MemoCreationが作成される（メモと作品が関連付けられる）" do
        expect {
          post from_memo_creation_plot_blocks_path(creation),
            params: { memo_id: memo.id }
        }.to change(MemoCreation, :count).by(1)
      end

      it "同じメモを2回追加してもMemoCreationは1件のみ作成される" do
        post from_memo_creation_plot_blocks_path(creation),
          params: { memo_id: memo.id }
        expect {
          post from_memo_creation_plot_blocks_path(creation),
            params: { memo_id: memo.id }
        }.not_to change(MemoCreation, :count)
      end

      it "Turbo Streamリクエストの場合はturbo_streamを返す" do
        post from_memo_creation_plot_blocks_path(creation),
          params: { memo_id: memo.id },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      end
    end

    context "他のユーザーのメモからは" do
      it "プロットブロックを作成できない" do
        other_user = create(:user)
        other_memo = create(:memo, user: other_user)
        expect {
          post from_memo_creation_plot_blocks_path(creation),
            params: { memo_id: other_memo.id }
        }.not_to change(PlotBlock, :count)
      end
    end
  end

  describe "POST /creations/:creation_id/plot_blocks/bulk_from_memo" do
    let(:memo1) { create(:memo, user: user) }
    let(:memo2) { create(:memo, user: user) }

    it "チェックしたメモをまとめてブロック化できる" do
      expect {
        post bulk_from_memo_creation_plot_blocks_path(creation),
          params: { memo_ids: [memo1.id, memo2.id] }
      }.to change(PlotBlock, :count).by(2)
    end

    it "positionが連番で割り当てられる" do
      post bulk_from_memo_creation_plot_blocks_path(creation),
        params: { memo_ids: [memo1.id, memo2.id] }
      positions = creation.plot_blocks.order(:position).pluck(:position)
      expect(positions).to eq [1, 2]
    end

    it "MemoCreationがメモの数だけ作成される" do
      expect {
        post bulk_from_memo_creation_plot_blocks_path(creation),
          params: { memo_ids: [memo1.id, memo2.id] }
      }.to change(MemoCreation, :count).by(2)
    end

    it "memo_idsが空の場合はブロックを作成しない" do
      expect {
        post bulk_from_memo_creation_plot_blocks_path(creation),
          params: { memo_ids: [] }
      }.not_to change(PlotBlock, :count)
    end

    it "Turbo Streamリクエストの場合はturbo_streamを返す" do
      post bulk_from_memo_creation_plot_blocks_path(creation),
        params: { memo_ids: [memo1.id, memo2.id] },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
    end
  end
end