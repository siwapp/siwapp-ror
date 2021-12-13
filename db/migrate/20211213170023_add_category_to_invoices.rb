class AddCategoryToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :commons, :category_id, :integer
    add_column :commons, :inventory_id, :integer
  end
end
