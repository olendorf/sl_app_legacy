class CreateChuckNorris < ActiveRecord::Migration[5.2]
  def change
    create_table :chuck_norris do |t|
      t.string :fact
      t.integer :knockouts

      t.timestamps
    end
  end
end
