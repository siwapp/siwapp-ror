class DefaultForEnabled < ActiveRecord::Migration
  def change
    change_column_default(:commons, :enabled, true)
    change_column_default(:commons, :draft, false)
  end
end
