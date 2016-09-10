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

ActiveRecord::Schema.define(version: 20160910152431) do

  create_table "commission_reports", force: :cascade do |t|
    t.string   "employee_name"
    t.string   "customer_name"
    t.integer  "account_manager_id"
    t.integer  "recruiter_id"
    t.integer  "support_id"
    t.decimal  "pay_rate"
    t.decimal  "total_hours"
    t.decimal  "total_gross_pay"
    t.decimal  "total_bill"
    t.decimal  "am_rate"
    t.decimal  "rec_rate"
    t.decimal  "sup_rate"
    t.decimal  "mark_up"
    t.date     "week_ending"
    t.date     "week_beginning"
    t.decimal  "revenue"
    t.decimal  "am_amount"
    t.decimal  "rec_amount"
    t.decimal  "sup_amount"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.date     "start_date"
    t.boolean  "double",             default: false
    t.integer  "customer_id"
  end

  add_index "commission_reports", ["account_manager_id"], name: "index_commission_reports_on_account_manager_id"
  add_index "commission_reports", ["customer_id"], name: "index_commission_reports_on_customer_id"
  add_index "commission_reports", ["recruiter_id"], name: "index_commission_reports_on_recruiter_id"
  add_index "commission_reports", ["support_id"], name: "index_commission_reports_on_support_id"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "role"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "advanced",               default: false
    t.boolean  "multi_rates",            default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
