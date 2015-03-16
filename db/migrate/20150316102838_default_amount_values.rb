class DefaultAmountValues < ActiveRecord::Migration
  def change
    change_column :commons, :base_amount, :decimal, :precision => 53, :scale => 15, :default => 0
    change_column :commons, :discount_amount, :decimal, :precision => 53, :scale => 15, :default => 0
    change_column :commons, :net_amount, :decimal, :precision => 53, :scale => 15, :default => 0
    change_column :commons, :gross_amount, :decimal, :precision => 53, :scale => 15, :default => 0
    change_column :commons, :paid_amount, :decimal, :precision => 53, :scale => 15, :default => 0
    change_column :commons, :tax_amount, :decimal, :precision => 53, :scale => 15, :default => 0
  end
end
