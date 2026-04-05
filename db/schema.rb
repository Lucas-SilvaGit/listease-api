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

ActiveRecord::Schema[8.1].define(version: 2026_04_05_000040) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "list_items", force: :cascade do |t|
    t.string "brand_snapshot"
    t.datetime "created_at", null: false
    t.bigint "list_id", null: false
    t.string "name_snapshot", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "product_id"
    t.boolean "purchased", default: false, null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id", "purchased"], name: "index_list_items_on_list_id_and_purchased"
    t.index ["list_id"], name: "index_list_items_on_list_id"
    t.index ["name_snapshot"], name: "index_list_items_on_name_snapshot"
    t.index ["product_id"], name: "index_list_items_on_product_id"
  end

  create_table "lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", default: "free", null: false
    t.integer "month"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "year"
    t.index ["user_id", "kind"], name: "index_lists_on_user_id_and_kind"
    t.index ["user_id", "updated_at"], name: "index_lists_on_user_id_and_updated_at"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "brand"
    t.string "category"
    t.datetime "created_at", null: false
    t.decimal "default_price", precision: 10, scale: 2
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "category"], name: "index_products_on_user_id_and_category"
    t.index ["user_id", "name"], name: "index_products_on_user_id_and_name"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "google_uid"
    t.string "name", null: false
    t.string "password_digest"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_uid"], name: "index_users_on_google_uid", unique: true
  end

  add_foreign_key "list_items", "lists"
  add_foreign_key "list_items", "products"
  add_foreign_key "lists", "users"
  add_foreign_key "products", "users"
end
