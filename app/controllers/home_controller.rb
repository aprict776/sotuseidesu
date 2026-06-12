class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    # ログイン済みの場合はメモ画面へリダイレクト
    redirect_to memos_path if user_signed_in?
  end
end
