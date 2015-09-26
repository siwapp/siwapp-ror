class ChangeCommonsCustomerFields < ActiveRecord::Migration
  def change
    rename_column :commons, :customer_name, :name
    rename_column :commons, :customer_identification, :identification
    rename_column :commons, :customer_email, :email
  end
end
