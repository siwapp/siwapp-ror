class RemoveTaxAmount < ActiveRecord::Migration[4.2]
  def change
    remove_column :commons, :tax_amount
  end
end
