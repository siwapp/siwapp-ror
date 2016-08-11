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

ActiveRecord::Schema.define(version: 20160811093550) do

  create_table "commons", force: :cascade do |t|
    t.integer  "series_id",            limit: 4
    t.integer  "customer_id",          limit: 4
    t.string   "name",                 limit: 100
    t.string   "identification",       limit: 50
    t.string   "email",                limit: 100
    t.text     "invoicing_address",    limit: 65535
    t.text     "shipping_address",     limit: 65535
    t.string   "contact_person",       limit: 100
    t.text     "terms",                limit: 65535
    t.text     "notes",                limit: 65535
    t.decimal  "base_amount",                        precision: 53, scale: 15, default: 0.0
    t.decimal  "discount_amount",                    precision: 53, scale: 15, default: 0.0
    t.decimal  "net_amount",                         precision: 53, scale: 15, default: 0.0
    t.decimal  "gross_amount",                       precision: 53, scale: 15, default: 0.0
    t.decimal  "paid_amount",                        precision: 53, scale: 15, default: 0.0
    t.decimal  "tax_amount",                         precision: 53, scale: 15, default: 0.0
    t.integer  "status",               limit: 1
    t.string   "type",                 limit: 255
    t.boolean  "draft",                                                        default: false
    t.boolean  "paid",                                                         default: false
    t.boolean  "sent_by_email",                                                default: false
    t.integer  "number",               limit: 4
    t.integer  "recurring_invoice_id", limit: 4
    t.date     "issue_date"
    t.date     "due_date"
    t.integer  "days_to_due",          limit: 3
    t.boolean  "enabled",                                                      default: false
    t.integer  "max_occurrences",      limit: 4
    t.integer  "must_occurrences",     limit: 4
    t.integer  "period",               limit: 4
    t.string   "period_type",          limit: 8
    t.date     "starting_date"
    t.date     "finishing_date"
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.datetime "deleted_at"
    t.integer  "template_id",          limit: 4
  end

  add_index "commons", ["contact_person"], name: "cntct_idx", using: :btree
  add_index "commons", ["customer_id"], name: "customer_id_idx", using: :btree
  add_index "commons", ["deleted_at"], name: "deleted_at_idx", using: :btree
  add_index "commons", ["email"], name: "cstml_idx", using: :btree
  add_index "commons", ["identification"], name: "cstid_idx", using: :btree
  add_index "commons", ["name"], name: "cstnm_idx", using: :btree
  add_index "commons", ["recurring_invoice_id"], name: "common_recurring_invoice_id_common_id", using: :btree
  add_index "commons", ["series_id"], name: "series_id_idx", using: :btree
  add_index "commons", ["type"], name: "common_type_idx", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name",              limit: 100
    t.string   "name_slug",         limit: 100
    t.string   "identification",    limit: 50
    t.string   "email",             limit: 100
    t.string   "contact_person",    limit: 100
    t.text     "invoicing_address", limit: 65535
    t.text     "shipping_address",  limit: 65535
    t.datetime "deleted_at"
  end

  add_index "customers", ["deleted_at"], name: "index_customers_on_deleted_at", using: :btree
  add_index "customers", ["name"], name: "cstm_idx", unique: true, using: :btree
  add_index "customers", ["name_slug"], name: "cstm_slug_idx", unique: true, using: :btree

  create_table "items", force: :cascade do |t|
    t.decimal  "quantity",                    precision: 53, scale: 15, default: 1.0, null: false
    t.decimal  "discount",                    precision: 53, scale: 2,  default: 0.0, null: false
    t.integer  "common_id",     limit: 4,                                             null: false
    t.string   "description",   limit: 20000
    t.date     "previous_date"
    t.date     "current_date"
    t.date     "next_date"
    t.decimal  "unitary_cost",                precision: 53, scale: 15, default: 0.0, null: false
    t.integer  "product_id",    limit: 4
    t.datetime "deleted_at"
  end

  add_index "items", ["common_id"], name: "common_id_idx", using: :btree
  add_index "items", ["deleted_at"], name: "item_deleted_at_idx", using: :btree
  add_index "items", ["description"], name: "desc_idx", length: {"description"=>255}, using: :btree
  add_index "items", ["product_id"], name: "item_product_id_idx", using: :btree

  create_table "items_taxes", id: false, force: :cascade do |t|
    t.integer "item_id", limit: 4, default: 0, null: false
    t.integer "tax_id",  limit: 4, default: 0, null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id", limit: 8,                               null: false
    t.date     "date"
    t.decimal  "amount",                   precision: 53, scale: 15
    t.text     "notes",      limit: 65535
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.datetime "deleted_at"
  end

  add_index "payments", ["deleted_at"], name: "payment_deleted_at_idx", using: :btree
  add_index "payments", ["invoice_id"], name: "invoice_id_idx", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "reference",   limit: 100,                                           null: false
    t.text     "description", limit: 65535
    t.decimal  "price",                     precision: 53, scale: 15, default: 0.0, null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.datetime "deleted_at"
  end

  add_index "products", ["deleted_at"], name: "product_deleted_at_idx", using: :btree

  create_table "series", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "value",       limit: 255
    t.integer  "next_number", limit: 4,   default: 1
    t.boolean  "enabled",                 default: true
    t.boolean  "default"
    t.datetime "deleted_at"
  end

  add_index "series", ["deleted_at"], name: "series_deleted_at_idx", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255,   null: false
    t.text     "value",      limit: 65535
    t.integer  "thing_id",   limit: 4
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "taggable_id",   limit: 4
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.boolean  "default"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "taxes", force: :cascade do |t|
    t.string   "name",       limit: 50
    t.decimal  "value",                 precision: 53, scale: 2
    t.boolean  "active",                                         default: true
    t.boolean  "default",                                        default: false
    t.datetime "deleted_at"
  end

  add_index "taxes", ["deleted_at"], name: "tax_deleted_at_idx", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "template",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "models",     limit: 200
    t.boolean  "default"
    t.datetime "deleted_at"
  end

  add_index "templates", ["deleted_at"], name: "template_deleted_at_idx", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "webhook_logs", force: :cascade do |t|
    t.string   "level",      limit: 255, default: "info", null: false
    t.string   "message",    limit: 255
    t.string   "event",      limit: 255,                  null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "webhook_logs", ["event"], name: "index_webhook_logs_on_event", using: :btree

end
