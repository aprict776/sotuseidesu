class MemosController < ApplicationController
  # update・destroyの前にset_memoを実行してメモを取得
  before_action :set_memo, only: [ :update, :destroy ]

  def index
    @memos = current_user.memos.order(created_at: :desc)
    @memo = Memo.new
    @creations = current_user.creations.order(created_at: :desc)
    @selected_creation = current_user.creations.find_by(id: params[:creation_id])
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      respond_to do |format|
        format.turbo_stream do
          # メモ一覧の先頭（#memosの中）に新しいメモカードを追加
          render turbo_stream: turbo_stream.prepend(
            "memos",
            partial: "memo",
            locals: { memo: @memo, creation_id: params[:creation_id] }
          )
        end
        format.html { redirect_to memos_path(creation_id: params[:creation_id]) }
      end
    else
      @memos     = current_user.memos.order(created_at: :desc)
      @creations = current_user.creations.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @memo.update(memo_params)
      respond_to do |format|
        format.turbo_stream do
          # 対象メモのカードだけを更新内容に差し替え
          render turbo_stream: turbo_stream.replace(
            @memo,
            partial: "memo",
            locals: { memo: @memo, creation_id: params[:creation_id] }
          )
        end
        format.html { redirect_to memos_path(creation_id: params[:creation_id]) }
      end
    else
      @memos     = current_user.memos.order(created_at: :desc)
      @creations = current_user.creations.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @memo.destroy
    respond_to do |format|
      format.turbo_stream do
        # 削除したメモのDOM要素だけを取り除く
        render turbo_stream: turbo_stream.remove(@memo)
      end
      format.html { redirect_to memos_path(creation_id: params[:creation_id]) }
    end
  end

  private

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:content)
  end

end