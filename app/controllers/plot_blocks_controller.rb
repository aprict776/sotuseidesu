class PlotBlocksController < ApplicationController
  before_action :set_creation

  def create
    @plot_block = @creation.plot_blocks.build(plot_block_params)
    @plot_block.position = @creation.plot_blocks.maximum(:position).to_i + 1

    if @plot_block.save
      respond_to do |format|
        format.turbo_stream do
          # 右パネルの#plot_blocksの末尾に新しいブロックを追加
          render turbo_stream: turbo_stream.append(
            "plot_blocks",
            partial: "plot_blocks/plot_block",
            locals: { plot_block: @plot_block }
          )
        end
        format.html { redirect_to memos_path(creation_id: @creation.id) }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to memos_path(creation_id: @creation.id), alert: "追加に失敗しました" }
      end
    end
  end

  def from_memo
    memo = current_user.memos.find(params[:memo_id])
    @plot_block = @creation.plot_blocks.build(
      content: memo.content,
      title: "",
      position: @creation.plot_blocks.maximum(:position).to_i + 1
    )

    if @plot_block.save
      MemoCreation.find_or_create_by(memo: memo, creation: @creation)

      respond_to do |format|
        format.turbo_stream do
          # 右パネルの#plot_blocksの末尾に追加
          render turbo_stream: turbo_stream.append(
            "plot_blocks",
            partial: "plot_blocks/plot_block",
            locals: { plot_block: @plot_block }
          )
        end
        format.html { redirect_to memos_path(creation_id: @creation.id) }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to memos_path(creation_id: @creation.id), alert: "追加に失敗しました" }
      end
    end
  end

  def bulk_from_memo
    memo_ids = params[:memo_ids]

    if memo_ids.blank?
      redirect_to memos_path(creation_id: @creation.id), alert: "メモを選択してください"
      return
    end

    memos = current_user.memos.where(id: memo_ids)

    # positionの最大値はループ外で1回だけ取得
    current_max_position = @creation.plot_blocks.maximum(:position).to_i

    plot_blocks_data = memos.map.with_index(1) do |memo, i|
      {
        creation_id: @creation.id,
        content: memo.content,
        title: "",
        position: current_max_position + i,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    # 一括INSERT（ループで1件ずつsaveより高速）
    PlotBlock.insert_all(plot_blocks_data)

    memo_creation_data = memos.map do |memo|
      {
        memo_id: memo.id,
        creation_id: @creation.id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end
    MemoCreation.insert_all(memo_creation_data)

    # bulk_from_memoは複数ブロックを一気に追加するため
    # ページリロードで右パネルをまとめて更新する（Turbo対応は複雑なため）
    redirect_to memos_path(creation_id: @creation.id), notice: "プロットに追加しました"
  end

  def destroy
    @plot_block = @creation.plot_blocks.find(params[:id])
    @plot_block.destroy

    respond_to do |format|
      format.turbo_stream do
        # 削除したブロックのDOM要素だけ取り除く
        render turbo_stream: turbo_stream.remove(@plot_block)
      end
      format.html { redirect_to memos_path(creation_id: @creation.id) }
    end
  end

  private

  def set_creation
    @creation = current_user.creations.find(params[:creation_id])
  end

  def plot_block_params
    params.require(:plot_block).permit(:title, :content)
  end
end