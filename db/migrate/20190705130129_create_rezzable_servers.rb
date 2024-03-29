class CreateRezzableServers < ActiveRecord::Migration[5.2]
  def change
    create_table :rezzable_servers do |t|
      t.integer :inventory_count, default: 0
    end
    
    add_index :rezzable_servers, :inventory_count
  end
end
