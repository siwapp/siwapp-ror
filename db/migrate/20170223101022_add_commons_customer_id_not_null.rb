class AddCommonsCustomerIdNotNull < ActiveRecord::Migration
  def change
      change_column :commons, :customer_id, :integer, :null => false
  end
end
