class MemosController < ApplicationController
  # メモの編集はモーダルとして実装したためeditアクションは削除
  before_action :set_memo, only: [:update, :destroy ]

  def index
    @memos = current_user.memos.order(created_at: :desc)
    @memo = Memo.new
    @creations = current_user.creations.order(created_at: :desc)
    @selected_creation = current_user.creations.find_by(id: params[:creation_id])
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      # creation_idを保持したままリダイレクト
      redirect_to memos_path(creation_id: params[:creation_id]), notice: "メモを投稿しました"
    else
      @memos = current_user.memos.order(created_at: :desc)
      @creations = current_user.creations.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @memo.update(memo_params)
      # creation_idを保持したままリダイレクト
      redirect_to memos_path(creation_id: params[:creation_id]), notice: "メモを更新しました"
    else
      @memos = current_user.memos.order(created_at: :desc)
      @creations = current_user.creations.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @memo.destroy
    # creation_idを保持したままリダイレクト
    redirect_to memos_path(creation_id: params[:creation_id]), notice: "メモを削除しました"
  end

  private

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:content)
  end
end
