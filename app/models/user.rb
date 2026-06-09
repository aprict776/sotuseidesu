class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memos, dependent: :destroy
  has_many :creations, dependent: :destroy

  validates :name, presence: true
end
