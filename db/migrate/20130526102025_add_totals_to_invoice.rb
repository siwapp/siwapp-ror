class AddTotalsToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :base_amount, :decimal, {:precision => 15, :scale => 3, :default => 0}
    add_column :invoices, :discount_amount, :decimal, {:precision => 15, :scale => 3, :default => 0}
    add_column :invoices, :net_amount, :decimal, {:precision => 15, :scale => 3, :default => 0}
    add_column :invoices, :tax_amount, :decimal, {:precision => 15, :scale => 3, :default => 0}
    add_column :invoices, :gross_amount, :decimal, {:precision => 15, :scale => 3, :default => 0}
    add_column :invoices, :paid_amount, :decimal, {:precision => 15, :scale => 3, :default => 0}
  end
end
