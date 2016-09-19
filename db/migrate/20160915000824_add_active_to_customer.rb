class AddActiveToCustomer < ActiveRecord::Migration
  def up
    add_column :customers, :active, :boolean, default: true
    Customer.update_all ["active = ?", true]
  end

  def down
    remove_column :customers, :active
  end

end
