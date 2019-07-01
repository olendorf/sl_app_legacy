class AddParentTransactionIdToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :analyzable_transactions, :parent_transaction_id, :integer
  end
end
