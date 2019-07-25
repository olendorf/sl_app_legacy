class CreateAnalyzableProductAliases < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_product_aliases do |t|
      t.string :alias_name
      t.integer :product_id

      t.timestamps
    end
    
    add_index :analyzable_product_aliases, :alias_name
    add_index :analyzable_product_aliases, :product_id
  end
end
