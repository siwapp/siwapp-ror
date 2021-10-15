class AddInvoiceNumberUniqueNumber < ActiveRecord::Migration[4.2]
  def change
  	add_index "commons", ["number", "series_id"], name: "common_unique_number_idx", unique: true, using: :btree
  end
end
