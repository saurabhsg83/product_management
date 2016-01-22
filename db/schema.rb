# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160121180704) do

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "status"
    t.string   "name"
    t.integer  "parent_category_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "categories", ["parent_category_id"], name: "index_categories_on_parent_category_id"

  create_table "product_inventories", force: :cascade do |t|
    t.integer  "status"
    t.integer  "cost_price"
    t.integer  "selling_price"
    t.integer  "quantity"
    t.integer  "product_size_id"
    t.integer  "property_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "product_sizes", force: :cascade do |t|
    t.integer  "status"
    t.integer  "product_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "size_list_id"
  end

  add_index "product_sizes", ["size_list_id"], name: "index_product_sizes_on_size_list_id"

  create_table "products", force: :cascade do |t|
    t.integer  "status"
    t.string   "name"
    t.text     "description"
    t.integer  "brand_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.integer  "property_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "properties", ["property_type_id"], name: "index_properties_on_property_type_id"

  create_table "property_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "size_lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "status_lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "token"
    t.string   "auth_token"
    t.boolean  "is_admin"
  end

end
