class AddTemplateSubject < ActiveRecord::Migration
  def change
  	add_column :templates, :subject, :string, limit: 200
  end
end
