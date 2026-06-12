class PlotBlock < ApplicationRecord
  belongs_to :creation

  # from_memoで作成する場合はtitleが空になるため、
  # titleのバリデーションをcontextで分ける
  validates :title, presence: true, on: :manual_create

  default_scope { order(:position) }
end
