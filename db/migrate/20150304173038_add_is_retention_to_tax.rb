class AddIsRetentionToTax < ActiveRecord::Migration
  def change
    add_column :taxes, :is_retention, :boolean, default: false
  end
end
