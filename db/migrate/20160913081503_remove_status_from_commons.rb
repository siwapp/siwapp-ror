class RemoveStatusFromCommons < ActiveRecord::Migration
  def change
    remove_column :commons, :status
  end
end
