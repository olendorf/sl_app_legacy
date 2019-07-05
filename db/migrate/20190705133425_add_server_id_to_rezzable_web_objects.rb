class AddServerIdToRezzableWebObjects < ActiveRecord::Migration[5.2]
  def change
    add_column :rezzable_web_objects, :server_id, :integer
    add_index :rezzable_web_objects, :server_id
  end
end
