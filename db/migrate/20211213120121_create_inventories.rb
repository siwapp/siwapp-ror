class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.string :name
      t.float :price
      t.integer :category_id

      t.timestamps
    end
  end
end
