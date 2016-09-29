class EmailAndPrintDefaultTemplatesToTemplate < ActiveRecord::Migration
  def change
  	rename_column :templates, :default, :print_default
  	add_column :templates, :email_default, :boolean
  end
end
