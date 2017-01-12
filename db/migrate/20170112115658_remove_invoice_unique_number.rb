class RemoveInvoiceUniqueNumber < ActiveRecord::Migration
  def change
    remove_index "commons", name: "common_unique_number_idx"
  end
end
