class AddPingedAtToRezzableWebObjects < ActiveRecord::Migration[5.2]
  def change
    add_column :rezzable_web_objects, :pinged_at, :datetime
  end
end
