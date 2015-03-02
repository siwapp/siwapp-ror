class AddTimestampsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :created_at, :datetime, null: false
    add_column :payments, :updated_at, :datetime, null: false

    # Don't allow payments without an invoice
    change_column_null :payments, :invoice_id, false
  end
end
