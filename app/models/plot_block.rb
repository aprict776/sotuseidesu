class PlotBlock < ApplicationRecord
  belongs_to :creation

  # タイトルのみ必須に変更（本文は後から編集）
  validates :title, presence: true

  default_scope { order(:position) }
end