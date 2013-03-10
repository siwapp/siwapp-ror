class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :date
      t.decimal :amount, precision: 5, scale: 2
      t.text :notes

      t.references :invoice

      t.timestamps
    end
  end
end
