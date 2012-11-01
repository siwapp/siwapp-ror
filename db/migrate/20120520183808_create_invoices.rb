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
