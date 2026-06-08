class MemosController < ApplicationController
  before_action :set_memo, only: [:edit, :update, :destroy]

  def index
    @memos = current_user.memos.order(created_at: :desc)
    @memo = Memo.new
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      redirect_to memos_path, notice: "メモを投稿しました"
    else
      @memos = current_user.memos.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @memo.update(memo_params)
      redirect_to memos_path, notice: "メモを更新しました"
    else
      @memos = current_user.memos.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end


  def edit
  end

  def update
    if @memo.update(memo_params)
      redirect_to memos_path, notice: "メモを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @memo.destroy
    redirect_to memos_path, notice: "メモを削除しました"
  end

  private

  def set_memo
    @memo = current_user.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:content)
  end
end
