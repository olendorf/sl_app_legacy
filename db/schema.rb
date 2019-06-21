# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_20_132905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chuck_norris", force: :cascade do |t|
    t.string "fact"
    t.integer "knockouts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rezzable_web_objects", force: :cascade do |t|
    t.string "object_name", null: false
    t.string "object_key", null: false
    t.string "description"
    t.string "region", null: false
    t.string "position", null: false
    t.string "url", null: false
    t.string "api_key", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_key"], name: "index_rezzable_web_objects_on_object_key", unique: true
    t.index ["object_name"], name: "index_rezzable_web_objects_on_object_name"
    t.index ["region"], name: "index_rezzable_web_objects_on_region"
    t.index ["user_id"], name: "index_rezzable_web_objects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_key", default: "", null: false
    t.string "avatar_name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0
    t.integer "object_weight", default: 0
    t.integer "account_level", default: 0
    t.datetime "expiration_date"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_level"], name: "index_users_on_account_level"
    t.index ["avatar_key"], name: "index_users_on_avatar_key", unique: true
    t.index ["avatar_name"], name: "index_users_on_avatar_name", unique: true
  end

end
