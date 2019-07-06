class CreateRezzableInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_inventories do |t|
      t.string :inventory_name
      t.integer :inventory_type,      null: false
      t.integer :owner_perms,         null: false, default: 0
      t.integer :next_perms,          null: false, default: 0
      t.integer :server_id

      t.timestamps
    end
    
    add_index :analyzable_inventories, [:server_id, :inventory_name], unique: true
    add_index :analyzable_inventories, :inventory_type
    add_index :analyzable_inventories, :owner_perms
    add_index :analyzable_inventories, :next_perms
  end
end
