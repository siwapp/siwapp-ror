class RemoveIsRetentionFromTaxes < ActiveRecord::Migration
  def change
    remove_column :taxes, :is_retention
  end
end
