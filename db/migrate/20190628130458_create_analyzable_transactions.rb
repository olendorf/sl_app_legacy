class CreateAnalyzableTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzable_transactions do |t|
      t.integer :amount,              null: false, default: 0
      t.integer :balance
      t.integer :category,            null: false, default: 0
      t.string :description
      t.integer :user_id
      t.integer :rezzable_id

      t.timestamps
    end
  end
end
