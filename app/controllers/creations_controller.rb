class CreationsController < ApplicationController
  before_action :set_creation, only: [ :destroy ]

  def create
    @creation = current_user.creations.build(creation_params)
    if @creation.save
      # creation_idパラメータを保持したままリダイレクト
      redirect_to memos_path(creation_id: params[:creation_id]), notice: "作品を作成しました"
    else
      redirect_to memos_path(creation_id: params[:creation_id]), alert: @creation.errors.full_messages.first #
    end
  end

  def destroy
    @creation.destroy
    # 削除した作品が選択中だった場合はcreation_idを渡さない
    selected_id = params[:creation_id].to_s == params[:id].to_s ? nil : params[:creation_id]
    redirect_to memos_path, notice: "作品を削除しました"
  end

  private

  def set_creation
    @creation = current_user.creations.find(params[:id])
  end

  def creation_params
    params.require(:creation).permit(:title)
  end
end
