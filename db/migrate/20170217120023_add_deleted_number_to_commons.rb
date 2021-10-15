class AddDeletedNumberToCommons < ActiveRecord::Migration[4.2]
  def change
    add_column :commons, :deleted_number, :integer, default: nil
    add_index "commons", ["series_id", "deleted_number"], name: "common_deleted_number_idx", using: :btree
  end
end
