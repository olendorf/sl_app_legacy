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

ActiveRecord::Schema.define(version: 2019_07_24_180705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "analyzable_inventories", force: :cascade do |t|
    t.string "inventory_name"
    t.integer "inventory_type", null: false
    t.integer "owner_perms", default: 0, null: false
    t.integer "next_perms", default: 0, null: false
    t.integer "server_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_type"], name: "index_analyzable_inventories_on_inventory_type"
    t.index ["next_perms"], name: "index_analyzable_inventories_on_next_perms"
    t.index ["owner_perms"], name: "index_analyzable_inventories_on_owner_perms"
    t.index ["server_id", "inventory_name"], name: "index_analyzable_inventories_on_server_id_and_inventory_name", unique: true
  end

  create_table "analyzable_products", force: :cascade do |t|
    t.string "product_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_name"], name: "index_analyzable_products_on_product_name"
  end

  create_table "analyzable_splits", force: :cascade do |t|
    t.string "target_name"
    t.string "target_key"
    t.float "percent"
    t.integer "splittable_id"
    t.string "splittable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "analyzable_transactions", force: :cascade do |t|
    t.integer "amount", default: 0, null: false
    t.integer "balance"
    t.integer "category", default: 0, null: false
    t.string "description"
    t.integer "user_id"
    t.integer "rezzable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "target_name"
    t.string "target_key"
    t.integer "parent_transaction_id"
    t.string "alert"
    t.integer "creator"
    t.string "transaction_key"
  end

  create_table "chuck_norris", force: :cascade do |t|
    t.string "fact"
    t.integer "knockouts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rezzable_servers", force: :cascade do |t|
    t.integer "inventory_count", default: 0
    t.index ["inventory_count"], name: "index_rezzable_servers_on_inventory_count"
  end

  create_table "rezzable_terminals", force: :cascade do |t|
  end

  create_table "rezzable_vendors", force: :cascade do |t|
    t.string "inventory_name"
    t.index ["inventory_name"], name: "index_rezzable_vendors_on_inventory_name"
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
    t.integer "weight"
    t.integer "actable_id"
    t.string "actable_type"
    t.datetime "pinged_at"
    t.integer "server_id"
    t.index ["object_key"], name: "index_rezzable_web_objects_on_object_key", unique: true
    t.index ["object_name"], name: "index_rezzable_web_objects_on_object_name"
    t.index ["region"], name: "index_rezzable_web_objects_on_region"
    t.index ["server_id"], name: "index_rezzable_web_objects_on_server_id"
    t.index ["user_id"], name: "index_rezzable_web_objects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_key", default: "", null: false
    t.string "avatar_name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0
    t.integer "object_weight", default: 0, null: false
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

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "transaction_id"
    t.integer "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

end
