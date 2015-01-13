class CommonTypes < ActiveRecord::Migration
  def change
    remove_foreign_key :common, name: :common_recurring_invoice_id_common_id
    remove_foreign_key :common, name: :common_customer_id_customer_id
    remove_foreign_key :common, name: :common_series_id_series_id
    remove_foreign_key :item, name: :item_common_id_common_id
    remove_foreign_key :item, name: :item_product_id_product_id
    remove_foreign_key :item_tax, name: :item_tax_item_id_item_id
    remove_foreign_key :payment, name: :payment_invoice_id_common_id
    remove_foreign_key :sf_guard_group_permission, name: :sf_guard_group_permission_group_id_sf_guard_group_id
    remove_foreign_key :sf_guard_group_permission, name: :sf_guard_group_permission_permission_id_sf_guard_permission_id
    remove_foreign_key :sf_guard_remember_key, name: :sf_guard_remember_key_user_id_sf_guard_user_id
    remove_foreign_key :sf_guard_user_group, name: :sf_guard_user_group_group_id_sf_guard_group_id
    remove_foreign_key :sf_guard_user_group, name: :sf_guard_user_group_user_id_sf_guard_user_id
    remove_foreign_key :sf_guard_user_permission, name: :sf_guard_user_permission_permission_id_sf_guard_permission_id
    remove_foreign_key :sf_guard_user_permission, name: :sf_guard_user_permission_user_id_sf_guard_user_id
    remove_foreign_key :sf_guard_user_profile, name: :sf_guard_user_profile_sf_guard_user_id_sf_guard_user_id

    drop_table :sf_guard_group
    drop_table :sf_guard_group_permission
    drop_table :sf_guard_permission
    drop_table :sf_guard_remember_key
    drop_table :sf_guard_user
    drop_table :sf_guard_user_group
    drop_table :sf_guard_user_permission
    drop_table :sf_guard_user_profile

    change_column :common, :id, :integer
    change_column :common, :recurring_invoice_id, :integer
    change_column :common, :series_id, :integer
    change_column :common, :customer_id, :integer
    change_column :common, :invoicing_address, :text
    change_column :common, :shipping_address, :text
  end
end
