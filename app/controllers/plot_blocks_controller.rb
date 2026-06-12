# app/controllers/plot_blocks_controller.rb
class PlotBlocksController < ApplicationController
  before_action :set_creation

  def create
    @plot_block = @creation.plot_blocks.build(plot_block_params)

    # positionを現在の最大値+1にして末尾に追加
    @plot_block.position = @creation.plot_blocks.maximum(:position).to_i + 1

    if @plot_block.save
      redirect_to memos_path(creation_id: @creation.id), notice: "プロットブロックを追加しました"
    else
      redirect_to memos_path(creation_id: @creation.id), alert: "追加に失敗しました"
    end
  end

  # メモの内容からブロックを作成するアクション
  def from_memo
    memo = current_user.memos.find(params[:memo_id])

    # メモのcontentをそのままコピーしてブロックを作成
    @plot_block = @creation.plot_blocks.build(
      content: memo.content,
      title: "",
      position: @creation.plot_blocks.maximum(:position).to_i + 1
    )

    if @plot_block.save
      # メモと作品を関連付け（memo_creationsに登録）
      # すでに関連付け済みの場合は重複登録しない
      MemoCreation.find_or_create_by(memo: memo, creation: @creation)

      redirect_to memos_path(creation_id: @creation.id), notice: "プロットに追加しました"
    else
      redirect_to memos_path(creation_id: @creation.id), alert: "追加に失敗しました"
    end
  end


  # チェックしたメモをまとめてブロック化するアクション
  def bulk_from_memo
    # チェックされたメモIDの配列を受け取る
    # 例: memo_ids: ["1", "3", "5"]
    memo_ids = params[:memo_ids]

    # memo_idsが空またはなければ何もしない
    if memo_ids.blank?
      redirect_to memos_path(creation_id: @creation.id), alert: "メモを選択してください"
      return
    end

    # チェックされたメモを自分のメモの中から取得
    memos = current_user.memos.where(id: memo_ids)

    # メモごとにブロックを1件ずつ作成
    memos.each do |memo|
      position = @creation.plot_blocks.maximum(:position).to_i + 1
      plot_block = @creation.plot_blocks.build(
        content: memo.content,
        title: "",
        position: position
      )
      if plot_block.save
        MemoCreation.find_or_create_by(memo: memo, creation: @creation)
      end
    end

    redirect_to memos_path(creation_id: @creation.id), notice: "プロットに追加しました"
  end

  def destroy
    @plot_block = @creation.plot_blocks.find(params[:id])
    @plot_block.destroy
    redirect_to memos_path(creation_id: @creation.id), notice: "プロットブロックを削除しました"
  end

  private

  # URLの :creation_id から作品を取得（自分の作品かもチェック）
  def set_creation
    @creation = current_user.creations.find(params[:creation_id])
  end

  def plot_block_params
    params.require(:plot_block).permit(:title, :content)
  end
end
