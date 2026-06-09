class CreateCreations < ActiveRecord::Migration[8.1]
  def change
    create_table :creations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, default: ""

      t.timestamps
    end
  end
end
