class RemoveCustomersUniqueName < ActiveRecord::Migration[4.2]
  def change
    remove_index "customers", name: "cstm_idx"
  end
end
