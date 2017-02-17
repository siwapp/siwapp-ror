class AddNumberWasToCommons < ActiveRecord::Migration
  def change
    add_column :commons, :number_was, :integer, default: nil
    add_index "commons", ["number_was", "series_id"], name: "common_number_was_idx", using: :btree
  end
end
