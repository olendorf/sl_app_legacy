class CreateRezzableInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :rezzable_inventories do |t|
      t.string :inventory_name
      t.integer :inventory_type
      t.integer :owner_perms
      t.integer :next_perms
      t.integer :server_id

      t.timestamps
    end
    
    add_index :rezzable_inventories, :inventory_name
    add_index :rezzable_inventories, :inventory_type
    add_index :rezzable_inventories, :owner_perms
    add_index :rezzable_inventories, :next_perms
  end
end
