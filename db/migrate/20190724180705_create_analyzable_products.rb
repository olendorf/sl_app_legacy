class CreateAnalyzableProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_products do |t|
      t.string :product_name

      t.timestamps
    end
    
    add_index :analyzable_products, :product_name
  end
end
