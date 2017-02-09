class RemoveCustomersUniqueName < ActiveRecord::Migration
  def change
    remove_index "customers", name: "cstm_idx"
  end
end
