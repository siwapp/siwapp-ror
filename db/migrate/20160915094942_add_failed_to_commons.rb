class AddFailedToCommons < ActiveRecord::Migration
  def change
    add_column :commons, :failed, :boolean, default: false
  end
end
