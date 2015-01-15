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

ActiveRecord::Schema.define(version: 20150113162521) do

  create_table "commons", force: :cascade do |t|
    t.integer  "series_id",               limit: 4
    t.integer  "customer_id",             limit: 4
    t.string   "customer_name",           limit: 100
    t.string   "customer_identification", limit: 50
    t.string   "customer_email",          limit: 100
    t.text     "invoicing_address",       limit: 65535
    t.text     "shipping_address",        limit: 65535
    t.string   "contact_person",          limit: 100
    t.text     "terms",                   limit: 65535
    t.text     "notes",                   limit: 65535
    t.decimal  "base_amount",                           precision: 53, scale: 15
    t.decimal  "discount_amount",                       precision: 53, scale: 15
    t.decimal  "net_amount",                            precision: 53, scale: 15
    t.decimal  "gross_amount",                          precision: 53, scale: 15
    t.decimal  "paid_amount",                           precision: 53, scale: 15
    t.decimal  "tax_amount",                            precision: 53, scale: 15
    t.integer  "status",                  limit: 1
    t.string   "type",                    limit: 255
    t.boolean  "draft",                   limit: 1,                               default: true
    t.boolean  "closed",                  limit: 1,                               default: false
    t.boolean  "sent_by_email",           limit: 1,                               default: false
    t.integer  "number",                  limit: 4
    t.integer  "recurring_invoice_id",    limit: 4
    t.date     "issue_date"
    t.date     "due_date"
    t.integer  "days_to_due",             limit: 3
    t.boolean  "enabled",                 limit: 1,                               default: false
    t.integer  "max_occurrences",         limit: 4
    t.integer  "must_occurrences",        limit: 4
    t.integer  "period",                  limit: 4
    t.string   "period_type",             limit: 8
    t.date     "starting_date"
    t.date     "finishing_date"
    t.date     "last_execution_date"
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
  end

  add_index "commons", ["contact_person"], name: "cntct_idx", using: :btree
  add_index "commons", ["customer_email"], name: "cstml_idx", using: :btree
  add_index "commons", ["customer_id"], name: "customer_id_idx", using: :btree
  add_index "commons", ["customer_identification"], name: "cstid_idx", using: :btree
  add_index "commons", ["customer_name"], name: "cstnm_idx", using: :btree
  add_index "commons", ["recurring_invoice_id"], name: "common_recurring_invoice_id_common_id", using: :btree
  add_index "commons", ["series_id"], name: "series_id_idx", using: :btree
  add_index "commons", ["type"], name: "common_type_idx", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string "name",              limit: 100
    t.string "name_slug",         limit: 100
    t.string "identification",    limit: 50
    t.string "email",             limit: 100
    t.string "contact_person",    limit: 100
    t.text   "invoicing_address", limit: 65535
    t.text   "shipping_address",  limit: 65535
  end

  add_index "customers", ["name"], name: "cstm_idx", unique: true, using: :btree
  add_index "customers", ["name_slug"], name: "cstm_slug_idx", unique: true, using: :btree

  create_table "item_tax", id: false, force: :cascade do |t|
    t.integer "item_id", limit: 4, default: 0, null: false
    t.integer "tax_id",  limit: 4, default: 0, null: false
  end

  create_table "items", force: :cascade do |t|
    t.decimal "quantity",                 precision: 53, scale: 15, default: 1.0, null: false
    t.decimal "discount",                 precision: 53, scale: 2,  default: 0.0, null: false
    t.integer "common_id",    limit: 4
    t.string  "description",  limit: 255
    t.decimal "unitary_cost",             precision: 53, scale: 15, default: 0.0, null: false
    t.integer "product_id",   limit: 4
  end

  add_index "items", ["common_id"], name: "common_id_idx", using: :btree
  add_index "items", ["description"], name: "desc_idx", using: :btree
  add_index "items", ["product_id"], name: "item_product_id_idx", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer "invoice_id", limit: 4
    t.date    "date"
    t.decimal "amount",                   precision: 53, scale: 15
    t.text    "notes",      limit: 65535
  end

  add_index "payments", ["invoice_id"], name: "invoice_id_idx", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "reference",   limit: 100,                                           null: false
    t.text     "description", limit: 65535
    t.decimal  "price",                     precision: 53, scale: 15, default: 0.0, null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  create_table "properties", primary_key: "keey", force: :cascade do |t|
    t.text "value", limit: 65535
  end

  create_table "series", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.string  "value",        limit: 255
    t.integer "first_number", limit: 4,   default: 1
    t.boolean "enabled",      limit: 1,   default: true
  end

  create_table "tag", force: :cascade do |t|
    t.string  "name",             limit: 100
    t.boolean "is_triple",        limit: 1
    t.string  "triple_namespace", limit: 100
    t.string  "triple_key",       limit: 100
    t.string  "triple_value",     limit: 100
  end

  add_index "tag", ["name"], name: "name_idx", using: :btree
  add_index "tag", ["triple_key"], name: "triple2_idx", using: :btree
  add_index "tag", ["triple_namespace"], name: "triple1_idx", using: :btree
  add_index "tag", ["triple_value"], name: "triple3_idx", using: :btree

  create_table "tagging", force: :cascade do |t|
    t.integer "tag_id",         limit: 4,  null: false
    t.string  "taggable_model", limit: 30
    t.integer "taggable_id",    limit: 4
  end

  add_index "tagging", ["tag_id"], name: "tag_idx", using: :btree
  add_index "tagging", ["taggable_model", "taggable_id"], name: "taggable_idx", using: :btree

  create_table "tax", force: :cascade do |t|
    t.string  "name",       limit: 50
    t.decimal "value",                 precision: 53, scale: 2
    t.boolean "active",     limit: 1,                           default: true
    t.boolean "is_default", limit: 1,                           default: false
  end

  create_table "templates", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "template",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "slug",       limit: 255
    t.string   "models",     limit: 200
  end

  add_index "templates", ["slug"], name: "template_sluggable_idx", unique: true, using: :btree

end
