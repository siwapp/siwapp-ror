class SeriesFirstNumber < ActiveRecord::Migration
  def change
  	add_column :series, :first_number, :integer, default: 1
  	remove_column :series, :next_number
  end
end
