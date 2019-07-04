class AddCreatorToAnalyzableTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :analyzable_transactions, :creator, :integer
    add_column :analyzable_transactions, :transaction_key, :string
  end
end
