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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130526102025) do

  create_table "invoice_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "quantity",                                    :default => 0
    t.decimal  "discount",     :precision => 5,  :scale => 2, :default => 0.0
    t.text     "description"
    t.decimal  "unitary_cost", :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "invoice_items_taxes", :force => true do |t|
    t.integer "invoice_item_id"
    t.integer "tax_id"
  end

  create_table "invoices", :force => true do |t|
    t.string   "customer_name"
    t.string   "customer_identification"
    t.string   "customer_email"
    t.text     "invoicing_address"
    t.text     "shipping_address"
    t.string   "contact_person"
    t.text     "terms"
    t.text     "notes"
    t.integer  "status"
    t.boolean  "closed"
    t.boolean  "sent_by_email"
    t.integer  "number"
    t.date     "issue_date"
    t.date     "due_date"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.decimal  "base_amount",             :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "discount_amount",         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "net_amount",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "tax_amount",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gross_amount",            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "paid_amount",             :precision => 15, :scale => 3, :default => 0.0
  end

  create_table "payments", :force => true do |t|
    t.date     "date"
    t.decimal  "amount",     :precision => 5, :scale => 2
    t.text     "notes"
    t.integer  "invoice_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "taxes", :force => true do |t|
    t.string   "name"
    t.decimal  "value",      :precision => 5, :scale => 2
    t.boolean  "active"
    t.boolean  "is_default"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

end
