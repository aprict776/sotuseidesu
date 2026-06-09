class Creation < ApplicationRecord
  belongs_to :user
  validates :title, 
    presence: { message: "を入力してください" },
  # なろう系小説タイトルの最長文字数を調べたところ134文字だったので作品タイトルの最大文字数を134文字までとする。ちなみにその小説のタイトルは「無駄だと追放された【宮廷獣医】、獣の国に好待遇で招かれる～森で助けた神獣とケモ耳美少女達にめちゃくちゃ溺愛されながらスローライフを楽しんでる「動物が言うこと聞かなくなったから帰って来い？今更もう遅い」～」
    length: { maximum: 134, message: "は134文字まで！" }
end
