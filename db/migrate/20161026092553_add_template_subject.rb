class AddTemplateSubject < ActiveRecord::Migration[4.2]
  def change
  	add_column :templates, :subject, :string, limit: 200
  end
end
