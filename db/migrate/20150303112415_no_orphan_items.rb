class NoOrphanItems < ActiveRecord::Migration
  def change
    # Don't allow items without an invoice/estimate/recurring invoice
    change_column_null :items, :common_id, false
  end
end
