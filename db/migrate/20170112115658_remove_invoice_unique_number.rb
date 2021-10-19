class RemoveInvoiceUniqueNumber < ActiveRecord::Migration[4.2]
  def change
    remove_index "commons", name: "common_unique_number_idx"
  end
end
