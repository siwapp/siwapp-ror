class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :name
      t.decimal :value, :precision => 5, :scale => 2
      t.boolean :active
      t.boolean :is_default

      t.timestamps
    end
  end
end
