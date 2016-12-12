class RemoveTaxAmount < ActiveRecord::Migration
  def change
    remove_column :commons, :tax_amount
  end
end
