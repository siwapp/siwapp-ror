class ChangeCustomerIndex < ActiveRecord::Migration[4.2]
  def change
  	remove_index "customers", name: "cstm_idx"
  	add_index "customers", ["name", "identification"], name: "cstm_idx", unique: true, using: :btree
  end
end
