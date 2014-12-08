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

ActiveRecord::Schema.define(version: 20141208012541) do

  create_table "bank_payments", force: true do |t|
    t.string   "accounting_status"
    t.string   "accounting_note"
    t.integer  "transaction_id"
    t.date     "paid_on"
    t.decimal  "amount",            precision: 10, scale: 2
    t.string   "currency"
    t.string   "account_name"
    t.string   "info"
    t.string   "vs"
    t.string   "ss"
    t.string   "ks"
    t.string   "account_number"
    t.string   "bank_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true

  create_table "payments", force: true do |t|
    t.string   "type"
    t.integer  "bank_payment_id"
    t.decimal  "amount"
    t.date     "paid_on"
    t.integer  "person_id"
    t.string   "name"
    t.string   "address"
    t.date     "born_on"
    t.string   "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
