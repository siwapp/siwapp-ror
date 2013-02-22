class AddDefaultsToInvoiceItems < ActiveRecord::Migration
  def up
    change_column_default :invoice_items, :quantity, 0
    change_column_default :invoice_items, :discount, 0
    change_column_default :invoice_items, :unitary_cost, 0
  end
  def down
    change_column_default :invoice_items, :quantity, nil
    change_column_default :invoice_items, :discount, nil
    change_column_default :invoice_items, :unitary_cost, nil
  end
end
