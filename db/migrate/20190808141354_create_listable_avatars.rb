class CreateListableAvatars < ActiveRecord::Migration[5.2]
  def change
    create_table :listable_avatars do |t|
      t.integer :listable_id
      t.string :listable_type
      t.string :avatar_name
      t.string :avatar_key
      t.string :list_name

      t.timestamps
    end
  end
end
