class AddWeightToRezzableWebObjects < ActiveRecord::Migration[5.2]
  def change
    add_column :rezzable_web_objects, :weight, :integer
  end
end
