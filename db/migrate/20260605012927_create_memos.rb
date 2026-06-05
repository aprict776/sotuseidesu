class CreateMemos < ActiveRecord::Migration[8.1]
  def change
    create_table :memos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false  # null: false を追加

      t.timestamps
    end
  end
end