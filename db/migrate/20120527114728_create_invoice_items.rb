class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :quantity
      t.decimal :discount, :precision => 5, :scale => 2
      t.text :description
      t.decimal :unitary_cost, :precision => 15, :scale => 3

      t.timestamps
    end
  end
end
