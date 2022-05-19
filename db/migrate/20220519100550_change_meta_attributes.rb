class ChangeMetaAttributes < ActiveRecord::Migration[5.2]
  def change
    change_column :commons, :meta_attributes, :jsonb, using: 'meta_attributes::text::jsonb'
  end
end
