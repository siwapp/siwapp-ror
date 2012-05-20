class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :customer_name
      t.string :customer_identification
      t.string :customer_email
      t.text :invoicing_address
      t.text :shipping_address
      t.string :contact_person
      t.text :terms
      t.text :notes
      t.decimal :base_amount, :precision => 15, :scale => 3
      t.decimal :discount_amount, :precision => 15, :scale => 3
      t.decimal :net_amount, :precision => 15, :scale => 3
      t.decimal :gross_amount, :precision => 15, :scale => 3
      t.decimal :paid_amount, :precision => 15, :scale => 3
      t.decimal :tax_amount, :precision => 15, :scale => 3
      t.integer :status
      t.boolean :closed
      t.boolean :sent_by_email
      t.integer :number
      t.date :issue_date
      t.date :due_date

      t.timestamps
    end
  end
end
