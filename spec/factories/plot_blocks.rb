FactoryBot.define do
  factory :plot_block do
    # タイトルは任意だが、テスト用にデフォルト値を設定
    title { "テストブロック" }
    # contentは空文字（タイトルのみで作成する仕様のため）
    content { "" }
    position { 0 }
    # どの作品に属するかの関連付け
    association :creation
  end
end