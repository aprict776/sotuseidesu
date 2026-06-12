Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  # メモのルーティング（editはモーダル表示するため削除）
  resources :memos, only: [ :index, :create, :update, :destroy ]

  resources :creations, only: [ :create, :destroy ] do
    resources :plot_blocks, only: [ :create, :destroy ] do
      # collection: ブロックIDを必要としないカスタムアクション
      collection do
        post :from_memo
        post :bulk_from_memo
      end
    end
  end

  root "home#index"
end
