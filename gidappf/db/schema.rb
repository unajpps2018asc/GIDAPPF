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

ActiveRecord::Schema.define(version: 2019_01_30_150903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "class_room_institutes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "ubication"
    t.datetime "available_from"
    t.datetime "available_to"
    t.boolean "available_monday"
    t.boolean "available_tuesday"
    t.boolean "available_wednesday"
    t.boolean "available_thursday"
    t.boolean "available_friday"
    t.boolean "available_saturday"
    t.boolean "available_sunday"
    t.integer "available_time"
    t.integer "capacity"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commissions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_commissions_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.boolean "enabled"
    t.datetime "updated_at", null: false
    t.float "level", default: 10.0
  end

  create_table "time_sheet_hours", force: :cascade do |t|
    t.bigint "time_sheet_id"
    t.string "hs_from"
    t.string "hs_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["time_sheet_id"], name: "index_time_sheet_hours_on_time_sheet_id"
  end

  create_table "time_sheets", force: :cascade do |t|
    t.bigint "commission_id"
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled"
    t.index ["commission_id"], name: "index_time_sheets_on_commission_id"
  end

  create_table "usercommissionroles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "commission_id"
    t.index ["commission_id"], name: "index_usercommissionroles_on_commission_id"
    t.index ["role_id"], name: "index_usercommissionroles_on_role_id"
    t.index ["user_id"], name: "index_usercommissionroles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vacancies", force: :cascade do |t|
    t.bigint "class_room_institute_id"
    t.bigint "user_id"
    t.integer "occupant"
    t.boolean "enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["class_room_institute_id"], name: "index_vacancies_on_class_room_institute_id"
    t.index ["user_id"], name: "index_vacancies_on_user_id"
  end

  add_foreign_key "commissions", "users"
  add_foreign_key "time_sheet_hours", "time_sheets"
  add_foreign_key "time_sheets", "commissions"
  add_foreign_key "usercommissionroles", "commissions"
  add_foreign_key "usercommissionroles", "roles"
  add_foreign_key "usercommissionroles", "users"
  add_foreign_key "vacancies", "class_room_institutes"
  add_foreign_key "vacancies", "users"
end
