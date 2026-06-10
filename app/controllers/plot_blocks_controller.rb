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