class PlotBlocksController < ApplicationController
  before_action :set_creation, only: [ :create, :from_memo, :bulk_from_memo ]
  before_action :set_plot_block, only: [ :edit, :update, :destroy ]

  def create
    @plot_block = @creation.plot_blocks.build(plot_block_params)
    @plot_block.position = @creation.plot_blocks.maximum(:position).to_i + 1

    if @plot_block.save
      respond_to do |format|
        format.turbo_stream do
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

  def update
    if @plot_block.update(plot_block_params)
      respond_to do |format|
        format.turbo_stream do
          # 執筆画面での保存ボタン用：ページ遷移なしで通知のみ更新
          render turbo_stream: turbo_stream.replace(
            "notice",
            partial: "plot_blocks/notice",
            locals: { message: "保存しました" }
          )
        end
        format.html do
          # 戻るボタン経由のfetch用：flashをセットしてリダイレクト
          flash[:notice] = "保存しました"
          redirect_to memos_path(creation_id: @creation.id)
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "notice",
            partial: "plot_blocks/notice",
            locals: { message: "保存に失敗しました" }
          )
        end
        format.html do
          flash[:alert] = "保存に失敗しました"
          redirect_to memos_path(creation_id: @creation.id)
        end
      end
    end
  end

  def destroy
    if @plot_block.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(@plot_block)
        end
        format.html { redirect_to memos_path(creation_id: @creation.id) }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to memos_path(creation_id: @creation.id), alert: "削除に失敗しました" }
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

    respond_to do |format|
      format.turbo_stream do
        new_blocks = @creation.plot_blocks
                               .where("position > ?", current_max_position)
                               .order(:position)

        render turbo_stream: new_blocks.map { |block|
          turbo_stream.append(
            "plot_blocks",
            partial: "plot_blocks/plot_block",
            locals: { plot_block: block }
          )
        }
      end
      format.html { redirect_to memos_path(creation_id: @creation.id), notice: "プロットに追加しました" }
    end
  end

  private

  def set_creation
    @creation = current_user.creations.find(params[:creation_id])
  end

  def set_plot_block
    @plot_block = PlotBlock.joins(:creation)
                           .where(creations: { user_id: current_user.id })
                           .find(params[:id])
    @creation = @plot_block.creation
  end

  def plot_block_params
    params.require(:plot_block).permit(:title, :content)
  end
end
