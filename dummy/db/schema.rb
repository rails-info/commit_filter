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

ActiveRecord::Schema.define(version: 20150318164960) do

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "page_module_collections", force: :cascade do |t|
    t.string   "slug"
    t.string   "slug_stub"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_module_collections", ["slug"], name: "index_page_module_collections_on_slug", unique: true
  add_index "page_module_collections", ["slug_stub"], name: "index_page_module_collections_on_slug_stub", unique: true

  create_table "page_module_collections_modules", force: :cascade do |t|
    t.integer  "collection_id"
    t.integer  "position"
    t.integer  "module_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_module_collections_modules", ["collection_id", "position", "module_id"], name: "uniq_page_module_collections_module", unique: true

  create_table "page_modules", force: :cascade do |t|
    t.string   "slug"
    t.string   "slug_stub"
    t.string   "title"
    t.string   "description"
    t.string   "partial_path"
    t.text     "content",         limit: 65535
    t.text     "data",            limit: 16777215
    t.string   "moduleable_type"
    t.integer  "moduleable_id"
    t.datetime "published_from"
    t.datetime "published_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_modules", ["moduleable_type", "moduleable_id"], name: "index_page_modules_on_moduleable_type_and_moduleable_id"
  add_index "page_modules", ["published_from"], name: "index_page_modules_on_published_from"
  add_index "page_modules", ["published_until"], name: "index_page_modules_on_published_until"
  add_index "page_modules", ["slug"], name: "index_page_modules_on_slug", unique: true
  add_index "page_modules", ["slug_stub"], name: "index_page_modules_on_slug_stub"

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "password"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true

end
