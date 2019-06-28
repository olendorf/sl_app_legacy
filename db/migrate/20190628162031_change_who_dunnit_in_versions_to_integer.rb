class ChangeWhoDunnitInVersionsToInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :versions, :whodunnit, :string
    add_column :versions, :whodunnit, :integer
  end
end
