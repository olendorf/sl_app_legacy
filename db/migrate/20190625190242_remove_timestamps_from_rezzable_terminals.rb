class RemoveTimestampsFromRezzableTerminals < ActiveRecord::Migration[5.2]
  def change
    remove_column :rezzable_terminals, :created_at, :datetime
    remove_column :rezzable_terminals, :updated_at, :datetime
  end
end
