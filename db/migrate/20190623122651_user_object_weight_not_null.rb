class UserObjectWeightNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:users, :object_weight, false)
  end
end
