class CreateAnalyzableProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_products do |t|
      t.string :product_name
      t.integer :user_id
      t.integer :price

      t.timestamps
    end
    
    add_index :analyzable_products, :product_name
    add_index :analyzable_products, :user_id
  end
end
