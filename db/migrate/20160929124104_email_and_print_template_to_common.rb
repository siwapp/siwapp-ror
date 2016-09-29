class EmailAndPrintTemplateToCommon < ActiveRecord::Migration
  def change
  	remove_column :commons, :template_id
  	add_column :commons, :print_template_id, :integer
  	add_column :commons, :email_template_id, :integer
  end
end
