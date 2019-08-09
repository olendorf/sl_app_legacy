class AddVersionNumbersToRezzableWebObject < ActiveRecord::Migration[5.2]
  def change
    add_column :rezzable_web_objects, :major_version, :integer
    add_column :rezzable_web_objects, :minor_version, :integer
    add_column :rezzable_web_objects, :patch_version, :integer
  end
end
