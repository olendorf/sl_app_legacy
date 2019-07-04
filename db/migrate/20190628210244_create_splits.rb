class CreateSplits < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_splits do |t|
      t.string :target_name
      t.string :target_key
      t.float :percent
      t.integer :splittable_id
      t.string :splittable_type

      t.timestamps
    end
  end
end
