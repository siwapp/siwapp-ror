class RenameClosedToPaid < ActiveRecord::Migration
  def change
    rename_column :commons, :closed, :paid
  end
end
