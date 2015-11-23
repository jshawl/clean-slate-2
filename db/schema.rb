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

ActiveRecord::Schema.define(version: 20151118165849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apartments", force: :cascade do |t|
    t.string "name"
  end

  create_table "expenses", force: :cascade do |t|
    t.datetime "created_at"
    t.integer  "amount"
    t.string   "description"
    t.integer  "user_id"
  end

  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "apartment_id" # nice! A stretch feature for the future might be allowing users to have multiple apartments.
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "temp_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["apartment_id"], name: "index_users_on_apartment_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "expenses", "users"
  add_foreign_key "users", "apartments"
end
