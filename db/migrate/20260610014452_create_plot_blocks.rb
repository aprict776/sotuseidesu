
class CreatePlotBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :plot_blocks do |t|
      # creationsテーブルへの外部キー（どの作品のブロックか）
      t.references :creation, null: false, foreign_key: true

      # ブロックのタイトル（任意入力なのでnull許可）
      t.string :title

      # 執筆内容（本文）
      t.text :content

      # 並び順（数字が小さいほど上に表示）
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end