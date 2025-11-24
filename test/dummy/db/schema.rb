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

ActiveRecord::Schema[8.1].define(version: 2025_11_24_153856) do
  create_table "gotcha_pon_histories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "executed_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "gotchable_id", null: false
    t.string "gotchable_type", null: false
    t.json "metadata", default: {}
    t.datetime "updated_at", null: false
    t.integer "user_id", null: true
    t.string "user_type", null: true
    t.index ["executed_at"], name: "index_gotcha_pon_histories_on_executed_at"
    t.index ["gotchable_type", "gotchable_id"], name: "index_gotcha_pon_histories_on_gotchable"
    t.index ["gotchable_type", "gotchable_id"], name: "index_gotcha_pon_histories_on_gotchable_type_and_gotchable_id"
    t.index ["user_type", "user_id"], name: "index_gotcha_pon_histories_on_user"
    t.index ["user_type", "user_id"], name: "index_gotcha_pon_histories_on_user_type_and_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "rarity"
    t.datetime "updated_at", null: false
    t.integer "weight"
  end
end
