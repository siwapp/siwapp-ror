class CreateInvoiceItemTaxes < ActiveRecord::Migration
  def change
    create_table :invoice_items_taxes do |t|
      t.integer :invoice_item_id
      t.integer :tax_id
    end
  end
end
