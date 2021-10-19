class RemoveStatusFromCommons < ActiveRecord::Migration[4.2]
  def change
    remove_column :commons, :status
  end
end
