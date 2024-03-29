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

ActiveRecord::Schema.define(version: 20140328150016) do

  create_table "items", force: true do |t|
    t.integer  "project_id"
    t.string   "key",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["project_id"], name: "index_items_on_project_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_languages", force: true do |t|
    t.integer  "project_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_languages", ["language_id"], name: "index_project_languages_on_language_id", using: :btree
  add_index "project_languages", ["project_id"], name: "index_project_languages_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "translations", force: true do |t|
    t.integer  "item_id"
    t.integer  "language_id"
    t.integer  "user_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["item_id"], name: "index_translations_on_item_id", using: :btree
  add_index "translations", ["language_id"], name: "index_translations_on_language_id", using: :btree
  add_index "translations", ["user_id"], name: "index_translations_on_user_id", using: :btree

  create_table "user_languages", force: true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_languages", ["language_id"], name: "index_user_languages_on_language_id", using: :btree
  add_index "user_languages", ["user_id"], name: "index_user_languages_on_user_id", using: :btree

  create_table "user_translations_scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "translation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "up"
  end

  add_index "user_translations_scores", ["translation_id"], name: "index_user_translations_scores_on_translation_id", using: :btree
  add_index "user_translations_scores", ["user_id", "translation_id"], name: "index_user_translations_scores_on_user_id_and_translation_id", unique: true, using: :btree
  add_index "user_translations_scores", ["user_id"], name: "index_user_translations_scores_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
