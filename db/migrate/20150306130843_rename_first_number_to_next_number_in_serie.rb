class RenameFirstNumberToNextNumberInSerie < ActiveRecord::Migration
  def change
    rename_column :series, :first_number, :next_number
  end
end
