class AddIndexToCommons < ActiveRecord::Migration[5.2]
  def change
      add_index "commons", ["type", "deleted_at"]
      add_index "commons", ["issue_date", "id"], order: {issue_date: :desc, id: :desc}
  end
end
