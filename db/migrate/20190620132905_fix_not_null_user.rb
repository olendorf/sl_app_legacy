class FixNotNullUser < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :avatar_key, "")
    change_column_default(:users, :avatar_name, "")
  end
end
