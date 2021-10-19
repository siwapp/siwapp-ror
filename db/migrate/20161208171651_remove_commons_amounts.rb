class RemoveCommonsAmounts < ActiveRecord::Migration[4.2]
  def change
    remove_column :commons, :discount_amount
    remove_column :commons, :base_amount
  end
end
