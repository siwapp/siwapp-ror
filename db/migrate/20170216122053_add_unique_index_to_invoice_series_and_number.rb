class AddUniqueIndexToInvoiceSeriesAndNumber < ActiveRecord::Migration[4.2]
  def change
    add_index "commons", ["series_id", "number"], name: "common_unique_number_idx", unique: true, using: :btree
  end
end
