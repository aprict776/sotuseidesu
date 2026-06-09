class CreateMemoCreations < ActiveRecord::Migration[8.1]
  def change
    create_table :memo_creations do |t|
      t.references :memo, null: false, foreign_key: true
      t.references :creation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
