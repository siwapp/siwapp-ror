class AddCommonsCustomerIdNotNull < ActiveRecord::Migration[4.2]
  def change
      change_column :commons, :customer_id, :integer, :null => false
  end
end
