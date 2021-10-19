class AddFailedToCommons < ActiveRecord::Migration[4.2]
  def change
    add_column :commons, :failed, :boolean, default: false
  end
end
