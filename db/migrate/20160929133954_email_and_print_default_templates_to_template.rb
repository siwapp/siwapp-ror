class EmailAndPrintDefaultTemplatesToTemplate < ActiveRecord::Migration[4.2]
  def change
  	rename_column :templates, :default, :print_default
  	add_column :templates, :email_default, :boolean, default: false
  end
end
