class CreateRezzableTerminals < ActiveRecord::Migration[5.2]
  def change
    create_table :rezzable_terminals do |t|

      t.timestamps
    end
  end
end
