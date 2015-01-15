class CreateDatabase < ActiveRecord::Migration
  def self.up
    # The database as it is on the symfony version of siwapp
    create_table "common", force: :cascade do |t|
      t.integer  "series_id",               limit: 8
      t.integer  "customer_id",             limit: 8
      t.string   "customer_name",           limit: 100
      t.string   "customer_identification", limit: 50
      t.string   "customer_email",          limit: 100
      t.text     "invoicing_address",       limit: 4294967295
      t.text     "shipping_address",        limit: 4294967295
      t.string   "contact_person",          limit: 100
      t.text     "terms",                   limit: 4294967295
      t.text     "notes",                   limit: 4294967295
      t.decimal  "base_amount",                                precision: 53, scale: 15
      t.decimal  "discount_amount",                            precision: 53, scale: 15
      t.decimal  "net_amount",                                 precision: 53, scale: 15
      t.decimal  "gross_amount",                               precision: 53, scale: 15
      t.decimal  "paid_amount",                                precision: 53, scale: 15
      t.decimal  "tax_amount",                                 precision: 53, scale: 15
      t.integer  "status",                  limit: 1
      t.string   "type",                    limit: 255
      t.boolean  "draft",                   limit: 1,                                    default: true
      t.boolean  "closed",                  limit: 1,                                    default: false
      t.boolean  "sent_by_email",           limit: 1,                                    default: false
      t.integer  "number",                  limit: 4
      t.integer  "recurring_invoice_id",    limit: 8
      t.date     "issue_date"
      t.date     "due_date"
      t.integer  "days_to_due",             limit: 3
      t.boolean  "enabled",                 limit: 1,                                    default: false
      t.integer  "max_occurrences",         limit: 4
      t.integer  "must_occurrences",        limit: 4
      t.integer  "period",                  limit: 4
      t.string   "period_type",             limit: 8
      t.date     "starting_date"
      t.date     "finishing_date"
      t.date     "last_execution_date"
      t.datetime "created_at",                                                                           null: false
      t.datetime "updated_at",                                                                           null: false
    end

    execute "ALTER TABLE common CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "common", ["contact_person"], name: "cntct_idx", using: :btree
    add_index "common", ["customer_email"], name: "cstml_idx", using: :btree
    add_index "common", ["customer_id"], name: "customer_id_idx", using: :btree
    add_index "common", ["customer_identification"], name: "cstid_idx", using: :btree
    add_index "common", ["customer_name"], name: "cstnm_idx", using: :btree
    add_index "common", ["recurring_invoice_id"], name: "common_recurring_invoice_id_common_id", using: :btree
    add_index "common", ["series_id"], name: "series_id_idx", using: :btree
    add_index "common", ["type"], name: "common_type_idx", using: :btree

    create_table "customer", force: :cascade do |t|
      t.string "name",              limit: 100
      t.string "name_slug",         limit: 100
      t.string "identification",    limit: 50
      t.string "email",             limit: 100
      t.string "contact_person",    limit: 100
      t.text   "invoicing_address", limit: 4294967295
      t.text   "shipping_address",  limit: 4294967295
    end
    execute "ALTER TABLE customer CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "customer", ["name"], name: "cstm_idx", unique: true, using: :btree
    add_index "customer", ["name_slug"], name: "cstm_slug_idx", unique: true, using: :btree

    create_table "item", force: :cascade do |t|
      t.decimal "quantity",                 precision: 53, scale: 15, default: 1.0, null: false
      t.decimal "discount",                 precision: 53, scale: 2,  default: 0.0, null: false
      t.integer "common_id",    limit: 8
      t.string  "description",  limit: 255
      t.decimal "unitary_cost",             precision: 53, scale: 15, default: 0.0, null: false
      t.integer "product_id",   limit: 8
    end
    execute "ALTER TABLE item CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "item", ["common_id"], name: "common_id_idx", using: :btree
    add_index "item", ["description"], name: "desc_idx", using: :btree
    add_index "item", ["product_id"], name: "item_product_id_idx", using: :btree

    create_table "item_tax", id: false, force: :cascade do |t|
      t.integer "item_id", limit: 8, default: 0, null: false
      t.integer "tax_id",  limit: 8, default: 0, null: false
    end
    execute "ALTER TABLE item_tax ADD PRIMARY KEY (`item_id`,`tax_id`);"

    create_table "migration_version", id: false, force: :cascade do |t|
      t.integer "version", limit: 4
    end

    create_table "payment", force: :cascade do |t|
      t.integer "invoice_id", limit: 8
      t.date    "date"
      t.decimal "amount",                        precision: 53, scale: 15
      t.text    "notes",      limit: 4294967295
    end
    execute "ALTER TABLE payment CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "payment", ["invoice_id"], name: "invoice_id_idx", using: :btree

    create_table "product", force: :cascade do |t|
      t.string   "reference",   limit: 100,                                                null: false
      t.text     "description", limit: 4294967295
      t.decimal  "price",                          precision: 53, scale: 15, default: 0.0, null: false
      t.datetime "created_at",                                                             null: false
      t.datetime "updated_at",                                                             null: false
    end
    execute "ALTER TABLE product CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    create_table "property", force: :cascade, id: false do |t|
      t.string "keey", limit: 50, null: false, default: ""
      t.text "value", limit: 4294967295
    end
    execute "ALTER TABLE property ADD PRIMARY KEY (keey);"

    create_table "series", force: :cascade do |t|
      t.string  "name",         limit: 255
      t.string  "value",        limit: 255
      t.integer "first_number", limit: 4,   default: 1
      t.boolean "enabled",      limit: 1,   default: true
    end
    execute "ALTER TABLE series CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    create_table "sf_guard_group", force: :cascade do |t|
      t.string   "name",        limit: 255
      t.text     "description", limit: 65535
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end

    add_index "sf_guard_group", ["name"], name: "name", unique: true, using: :btree

    create_table "sf_guard_group_permission", id: false, force: :cascade do |t|
      t.integer  "group_id",      limit: 4, default: 0, null: false
      t.integer  "permission_id", limit: 4, default: 0, null: false
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
    end

    add_index "sf_guard_group_permission", ["permission_id"], name: "sf_guard_group_permission_permission_id_sf_guard_permission_id", using: :btree

    create_table "sf_guard_permission", force: :cascade do |t|
      t.string   "name",        limit: 255
      t.text     "description", limit: 65535
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end

    add_index "sf_guard_permission", ["name"], name: "name", unique: true, using: :btree

    create_table "sf_guard_remember_key", id: false, force: :cascade do |t|
      t.integer  "id",           limit: 4,               null: false
      t.integer  "user_id",      limit: 4
      t.string   "remember_key", limit: 32
      t.string   "ip_address",   limit: 50, default: "", null: false
      t.datetime "created_at",                           null: false
      t.datetime "updated_at",                           null: false
    end

    add_index "sf_guard_remember_key", ["user_id"], name: "user_id_idx", using: :btree

    create_table "sf_guard_user", force: :cascade do |t|
      t.string   "username",       limit: 128,                  null: false
      t.string   "algorithm",      limit: 128, default: "sha1", null: false
      t.string   "salt",           limit: 128
      t.string   "password",       limit: 128
      t.boolean  "is_active",      limit: 1,   default: true
      t.boolean  "is_super_admin", limit: 1,   default: false
      t.datetime "last_login"
      t.datetime "created_at",                                  null: false
      t.datetime "updated_at",                                  null: false
    end

    add_index "sf_guard_user", ["is_active"], name: "is_active_idx_idx", using: :btree
    add_index "sf_guard_user", ["username"], name: "username", unique: true, using: :btree

    create_table "sf_guard_user_group", id: false, force: :cascade do |t|
      t.integer  "user_id",    limit: 4, default: 0, null: false
      t.integer  "group_id",   limit: 4, default: 0, null: false
      t.datetime "created_at",                       null: false
      t.datetime "updated_at",                       null: false
    end

    add_index "sf_guard_user_group", ["group_id"], name: "sf_guard_user_group_group_id_sf_guard_group_id", using: :btree

    create_table "sf_guard_user_permission", id: false, force: :cascade do |t|
      t.integer  "user_id",       limit: 4, default: 0, null: false
      t.integer  "permission_id", limit: 4, default: 0, null: false
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
    end

    add_index "sf_guard_user_permission", ["permission_id"], name: "sf_guard_user_permission_permission_id_sf_guard_permission_id", using: :btree

    create_table "sf_guard_user_profile", force: :cascade do |t|
      t.integer "sf_guard_user_id",   limit: 4
      t.string  "first_name",         limit: 50
      t.string  "last_name",          limit: 50
      t.string  "email",              limit: 100
      t.integer "nb_display_results", limit: 2
      t.string  "language",           limit: 3
      t.string  "country",            limit: 2
      t.string  "search_filter",      limit: 30
      t.string  "series",             limit: 50
      t.string  "hash",               limit: 50
    end

    add_index "sf_guard_user_profile", ["email"], name: "email", unique: true, using: :btree
    add_index "sf_guard_user_profile", ["sf_guard_user_id"], name: "sf_guard_user_id_idx", using: :btree

    create_table "tag", force: :cascade do |t|
      t.string  "name",             limit: 100
      t.boolean "is_triple",        limit: 1
      t.string  "triple_namespace", limit: 100
      t.string  "triple_key",       limit: 100
      t.string  "triple_value",     limit: 100
    end
    execute "ALTER TABLE tag CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "tag", ["name"], name: "name_idx", using: :btree
    add_index "tag", ["triple_key"], name: "triple2_idx", using: :btree
    add_index "tag", ["triple_namespace"], name: "triple1_idx", using: :btree
    add_index "tag", ["triple_value"], name: "triple3_idx", using: :btree

    create_table "tagging", force: :cascade do |t|
      t.integer "tag_id",         limit: 8,  null: false
      t.string  "taggable_model", limit: 30
      t.integer "taggable_id",    limit: 8
    end
    execute "ALTER TABLE tagging CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "tagging", ["tag_id"], name: "tag_idx", using: :btree
    add_index "tagging", ["taggable_model", "taggable_id"], name: "taggable_idx", using: :btree

    create_table "tax", force: :cascade do |t|
      t.string  "name",       limit: 50
      t.decimal "value",                 precision: 53, scale: 2
      t.boolean "active",     limit: 1,                           default: true
      t.boolean "is_default", limit: 1,                           default: false
    end
    execute "ALTER TABLE tax CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    create_table "template", force: :cascade do |t|
      t.string   "name",       limit: 255
      t.text     "template",   limit: 4294967295
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.string   "slug",       limit: 255
      t.string   "models",     limit: 200
    end
    execute "ALTER TABLE template CHANGE `id` `id` BIGINT(20) NOT NULL AUTO_INCREMENT;"

    add_index "template", ["slug"], name: "template_sluggable_idx", unique: true, using: :btree
 
    add_foreign_key "common", "common", column: "recurring_invoice_id", name: "common_recurring_invoice_id_common_id", on_delete: :nullify
    add_foreign_key "common", "customer", name: "common_customer_id_customer_id", on_delete: :nullify
    add_foreign_key "common", "series", name: "common_series_id_series_id", on_delete: :nullify
    add_foreign_key "item", "common", name: "item_common_id_common_id", on_delete: :cascade
    add_foreign_key "item", "product", name: "item_product_id_product_id", on_delete: :nullify
    add_foreign_key "item_tax", "item", name: "item_tax_item_id_item_id", on_delete: :cascade
    add_foreign_key "payment", "common", column: "invoice_id", name: "payment_invoice_id_common_id", on_delete: :cascade
    add_foreign_key "sf_guard_group_permission", "sf_guard_group", column: "group_id", name: "sf_guard_group_permission_group_id_sf_guard_group_id", on_delete: :cascade
    add_foreign_key "sf_guard_group_permission", "sf_guard_permission", column: "permission_id", name: "sf_guard_group_permission_permission_id_sf_guard_permission_id", on_delete: :cascade
    add_foreign_key "sf_guard_remember_key", "sf_guard_user", column: "user_id", name: "sf_guard_remember_key_user_id_sf_guard_user_id", on_delete: :cascade
    add_foreign_key "sf_guard_user_group", "sf_guard_group", column: "group_id", name: "sf_guard_user_group_group_id_sf_guard_group_id", on_delete: :cascade
    add_foreign_key "sf_guard_user_group", "sf_guard_user", column: "user_id", name: "sf_guard_user_group_user_id_sf_guard_user_id", on_delete: :cascade
    add_foreign_key "sf_guard_user_permission", "sf_guard_permission", column: "permission_id", name: "sf_guard_user_permission_permission_id_sf_guard_permission_id", on_delete: :cascade
    add_foreign_key "sf_guard_user_permission", "sf_guard_user", column: "user_id", name: "sf_guard_user_permission_user_id_sf_guard_user_id", on_delete: :cascade
    add_foreign_key "sf_guard_user_profile", "sf_guard_user", name: "sf_guard_user_profile_sf_guard_user_id_sf_guard_user_id", on_delete: :cascade
  end
end
