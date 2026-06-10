# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_10_014452) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "creations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title", default: "", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_creations_on_user_id"
  end

  create_table "memo_creations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creation_id", null: false
    t.bigint "memo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["creation_id"], name: "index_memo_creations_on_creation_id"
    t.index ["memo_id"], name: "index_memo_creations_on_memo_id"
  end

  create_table "memos", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_memos_on_user_id"
  end

  create_table "plot_blocks", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "creation_id", null: false
    t.integer "position", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["creation_id"], name: "index_plot_blocks_on_creation_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "creations", "users"
  add_foreign_key "memo_creations", "creations"
  add_foreign_key "memo_creations", "memos"
  add_foreign_key "memos", "users"
  add_foreign_key "plot_blocks", "creations"
end
