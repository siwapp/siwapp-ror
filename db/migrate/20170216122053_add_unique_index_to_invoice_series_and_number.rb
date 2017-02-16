class AddUniqueIndexToInvoiceSeriesAndNumber < ActiveRecord::Migration
  def change
    add_index "commons", ["series_id", "number"], name: "common_unique_number_idx", unique: true, using: :btree
  end
end
