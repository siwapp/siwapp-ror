class AddCurrencyToCommons < ActiveRecord::Migration[4.2]
  def up
    add_column :commons, :currency, :string, limit: 3
    currency = Settings.currency
    Common.find_each do |common|
      common.currency = currency
      common.save!
    end
  end

  def down
    remove_column :commons, :currency
  end
end
