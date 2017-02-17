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

ActiveRecord::Schema.define(version: 20170217120023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commons", force: :cascade do |t|
    t.integer  "series_id"
    t.integer  "customer_id"
    t.string   "name",                 limit: 100
    t.string   "identification",       limit: 50
    t.string   "email",                limit: 100
    t.text     "invoicing_address"
    t.text     "shipping_address"
    t.string   "contact_person",       limit: 100
    t.text     "terms"
    t.text     "notes"
    t.decimal  "net_amount",                       precision: 53, scale: 15, default: 0.0
    t.decimal  "gross_amount",                     precision: 53, scale: 15, default: 0.0
    t.decimal  "paid_amount",                      precision: 53, scale: 15, default: 0.0
    t.string   "type",                 limit: 255
    t.boolean  "draft",                                                      default: false
    t.boolean  "paid",                                                       default: false
    t.boolean  "sent_by_email",                                              default: false
    t.integer  "number"
    t.integer  "recurring_invoice_id"
    t.date     "issue_date"
    t.date     "due_date"
    t.integer  "days_to_due"
    t.boolean  "enabled",                                                    default: true
    t.integer  "max_occurrences"
    t.integer  "must_occurrences"
    t.integer  "period"
    t.string   "period_type",          limit: 8
    t.date     "starting_date"
    t.date     "finishing_date"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.datetime "deleted_at"
    t.integer  "print_template_id"
    t.text     "meta_attributes"
    t.boolean  "failed",                                                     default: false
    t.integer  "email_template_id"
    t.integer  "deleted_number"
  end

  add_index "commons", ["contact_person"], name: "cntct_idx", using: :btree
  add_index "commons", ["customer_id"], name: "customer_id_idx", using: :btree
  add_index "commons", ["deleted_at"], name: "index_commons_on_deleted_at", using: :btree
  add_index "commons", ["email"], name: "cstml_idx", using: :btree
  add_index "commons", ["identification"], name: "cstid_idx", using: :btree
  add_index "commons", ["name"], name: "cstnm_idx", using: :btree
  add_index "commons", ["recurring_invoice_id"], name: "common_recurring_invoice_id_common_id", using: :btree
  add_index "commons", ["series_id", "deleted_number"], name: "common_deleted_number_idx", using: :btree
  add_index "commons", ["series_id", "number"], name: "common_unique_number_idx", unique: true, using: :btree
  add_index "commons", ["series_id"], name: "series_id_idx", using: :btree
  add_index "commons", ["type"], name: "common_type_idx", using: :btree
  add_index "commons", ["type"], name: "type_and_status_idx", using: :btree

  create_table "customers", force: :cascade do |t|
    t.string   "name",              limit: 100
    t.string   "name_slug",         limit: 100
    t.string   "identification",    limit: 50
    t.string   "email",             limit: 100
    t.string   "contact_person",    limit: 100
    t.text     "invoicing_address"
    t.text     "shipping_address"
    t.datetime "deleted_at"
    t.text     "meta_attributes"
    t.boolean  "active",                        default: true
  end

  add_index "customers", ["deleted_at"], name: "index_customers_on_deleted_at", using: :btree
  add_index "customers", ["name_slug"], name: "cstm_slug_idx", unique: true, using: :btree

  create_table "items", force: :cascade do |t|
    t.decimal  "quantity",                   precision: 53, scale: 15, default: 1.0, null: false
    t.decimal  "discount",                   precision: 53, scale: 2,  default: 0.0, null: false
    t.integer  "common_id"
    t.string   "description",  limit: 20000
    t.decimal  "unitary_cost",               precision: 53, scale: 15, default: 0.0, null: false
    t.integer  "product_id"
    t.datetime "deleted_at"
  end

  add_index "items", ["common_id"], name: "common_id_idx", using: :btree
  add_index "items", ["deleted_at"], name: "index_items_on_deleted_at", using: :btree
  add_index "items", ["description"], name: "desc_idx", using: :btree
  add_index "items", ["product_id"], name: "item_product_id_idx", using: :btree

  create_table "items_taxes", id: false, force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "tax_id",  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id", limit: 8,                           null: false
    t.date     "date"
    t.decimal  "amount",               precision: 53, scale: 15
    t.text     "notes"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.datetime "deleted_at"
  end

  add_index "payments", ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
  add_index "payments", ["invoice_id"], name: "invoice_id_idx", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "reference",   limit: 100,                                         null: false
    t.text     "description"
    t.decimal  "price",                   precision: 53, scale: 15, default: 0.0, null: false
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.datetime "deleted_at"
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at", using: :btree

  create_table "series", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "value",        limit: 255
    t.boolean  "enabled",                  default: true
    t.boolean  "default",                  default: false
    t.datetime "deleted_at"
    t.integer  "first_number",             default: 1
  end

  add_index "series", ["deleted_at"], name: "index_series_on_deleted_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255, null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type", limit: 255
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "taxes", force: :cascade do |t|
    t.string   "name",       limit: 50
    t.decimal  "value",                 precision: 53, scale: 2
    t.boolean  "active",                                         default: true
    t.boolean  "default",                                        default: false
    t.datetime "deleted_at"
  end

  add_index "taxes", ["deleted_at"], name: "index_taxes_on_deleted_at", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "template"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "models",        limit: 200
    t.boolean  "print_default",             default: false
    t.datetime "deleted_at"
    t.boolean  "email_default",             default: false
    t.string   "subject",       limit: 200
  end

  add_index "templates", ["deleted_at"], name: "index_templates_on_deleted_at", using: :btree

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
