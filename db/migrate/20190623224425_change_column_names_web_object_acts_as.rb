class ChangeColumnNamesWebObjectActsAs < ActiveRecord::Migration[5.2]
  def change
    rename_column :rezzable_web_objects, :rezzable_id, :actable_id
    rename_column :rezzable_web_objects, :rezzable_type, :actable_type
  end
end
