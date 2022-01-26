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

ActiveRecord::Schema.define(version: 2022_01_26_130342) do

  create_table "estimation_values", force: :cascade do |t|
    t.integer "value"
    t.integer "placement"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["placement"], name: "index_estimation_values_on_placement", unique: true
    t.index ["value"], name: "index_estimation_values_on_value", unique: true
  end

  create_table "room_users", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_room_users_on_room_id"
    t.index ["user_id"], name: "index_room_users_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_rooms_on_name", unique: true
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "rooms_users", id: false, force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id", null: false
    t.index ["room_id"], name: "index_rooms_users_on_room_id"
    t.index ["user_id"], name: "index_rooms_users_on_user_id"
  end

  create_table "user_stories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "room_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_user_stories_on_room_id"
    t.index ["title", "room_id"], name: "index_user_stories_on_title_and_room_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", null: false
    t.boolean "isAdmin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "room_users", "rooms"
  add_foreign_key "room_users", "users"
  add_foreign_key "rooms", "users"
  add_foreign_key "user_stories", "rooms"
end
