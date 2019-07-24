class CreateAnalyzableProductNames < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_product_names do |t|
      t.string :product_name
      t.integer :product_id

      t.timestamps
    end
    
    add_index :analyzable_product_names, :product_name
    add_index :analyzable_product_names, :product_id
  end
end
