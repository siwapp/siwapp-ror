class EmailAndPrintTemplateToCommon < ActiveRecord::Migration
  def change
  	rename_column :commons, :template_id, :print_template_id
  	add_column :commons, :email_template_id, :integer
  end
end
