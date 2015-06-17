class RemoveSlugFromTemplates < ActiveRecord::Migration
  def change
    remove_column :templates, :slug
  end
end
