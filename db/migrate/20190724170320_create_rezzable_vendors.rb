class CreateRezzableVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :rezzable_vendors do |t|
      t.string :inventory_name
    end
    
    add_index :rezzable_vendors, :inventory_name
  end
end
