Rails.application.routes.draw do
   devise_for :users

   get "up" => "rails/health#show", as: :rails_health_check

   # メモのルーティング（editはモーダル表示するため削除）
   resources :memos, only: [ :index, :create, :update, :destroy ]

   # 作品とプロットブロックのルーティング
   # shallow: true により、ブロック単体操作（edit/update/destroy）は
   # /plot_blocks/:id の短いURLになる
   resources :creations, only: [ :create, :destroy ], shallow: true do
     resources :plot_blocks, only: [ :create, :destroy, :edit, :update ] do
       collection do
         post :from_memo
         post :bulk_from_memo
       end
     end
   end

   root "home#index"
 end
