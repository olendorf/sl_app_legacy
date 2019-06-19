class CreateRezzableWebObjects < ActiveRecord::Migration[5.2]
  def change
    create_table :rezzable_web_objects do |t|
      t.string :object_name,          null: false
      t.string :object_key,           null: false
      t.string :description  
      t.string :owner_key,           null: false
      t.string :region,              null: false
      t.string :position,            null: false
      t.string :url,                 null: false
      t.string :api_key,             null: false
      t.integer :user_id

      t.timestamps
    end
    
    add_index :rezzable_web_objects, :object_name
    add_index :rezzable_web_objects, :object_key,     unique: true
    add_index :rezzable_web_objects, :owner_key
    add_index :rezzable_web_objects, :region
  end
end
