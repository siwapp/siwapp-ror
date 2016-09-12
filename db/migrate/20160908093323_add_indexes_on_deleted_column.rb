class AddIndexesOnDeletedColumn < ActiveRecord::Migration
  def change
    add_index :commons, :deleted_at
    add_index :customers, :deleted_at
    add_index :items, :deleted_at
    add_index :payments, :deleted_at
    add_index :products, :deleted_at
    add_index :series, :deleted_at
    add_index :taxes, :deleted_at
    add_index :templates, :deleted_at
  end
end
