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

ActiveRecord::Schema.define(version: 20161207003803) do

  create_table "accountings", force: true do |t|
    t.string   "accountable_type"
    t.integer  "accountable_id"
    t.integer  "budget_category_id"
    t.string   "payment_type"
    t.integer  "payment_id"
    t.decimal  "amount",             precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_accounts", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "account_type"
    t.string   "account_number"
    t.string   "bank_code"
    t.decimal  "balance",        precision: 10, scale: 0
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_payments", force: true do |t|
    t.string   "accounting_status"
    t.string   "accounting_note"
    t.string   "transaction_id"
    t.date     "paid_on"
    t.decimal  "amount",             precision: 10, scale: 2
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
    t.integer  "organization_id"
    t.string   "our_account_number"
    t.string   "our_bank_code"
  end

  create_table "budget_categories", force: true do |t|
    t.integer  "organization_id"
    t.integer  "year"
    t.string   "name"
    t.decimal  "amount",          precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_form_submissions", force: true do |t|
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donations", force: true do |t|
    t.integer  "organization_id"
    t.decimal  "amount",          precision: 10, scale: 2
    t.string   "donor_type"
    t.integer  "person_id"
    t.string   "name"
    t.string   "ic"
    t.string   "date_of_birth"
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gopay_payments", force: true do |t|
    t.string   "transaction_id"
    t.date     "paid_on"
    t.float    "amount"
    t.string   "currency"
    t.string   "account_name"
    t.string   "info"
    t.string   "vs"
    t.string   "reference_id"
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "organization_id"
    t.string   "description"
    t.decimal  "amount",                precision: 10, scale: 2
    t.string   "vs"
    t.string   "ss"
    t.string   "ks"
    t.string   "account_number"
    t.string   "bank_code"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "exported_to_fio"
  end

  create_table "membership_fees", force: true do |t|
    t.integer  "region_id"
    t.decimal  "amount",      precision: 10, scale: 0
    t.integer  "person_id"
    t.string   "name"
    t.date     "received_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_number"
    t.string   "token"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", unique: true, using: :btree

  create_table "payments", force: true do |t|
    t.string   "payment_type"
    t.integer  "payment_id"
    t.decimal  "amount",       precision: 10, scale: 2
    t.string   "payable_type"
    t.integer  "payable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
