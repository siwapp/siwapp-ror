class RemoveCommonsAmounts < ActiveRecord::Migration
  def change
    remove_column :commons, :discount_amount
    remove_column :commons, :base_amount
  end
end
