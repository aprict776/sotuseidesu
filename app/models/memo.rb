class Memo < ApplicationRecord
  belongs_to :user

  # メモ削除時にmemo_creationsも一緒に削除する
  has_many :memo_creations, dependent: :destroy
  has_many :creations, through: :memo_creations

  validates :content, presence: true
end