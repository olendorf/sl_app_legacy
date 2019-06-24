class AddRezzableIdRezzableTypeToRezzableWebObject < ActiveRecord::Migration[5.2]
  def change
    add_column :rezzable_web_objects, :rezzable_id, :integer
    add_column :rezzable_web_objects, :rezzable_type, :string
  end
end
