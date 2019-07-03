ActiveAdmin.register Analyzable::Transaction do
  
  menu label: 'Transactions', parent: 'Data'
  
  actions :all, except: [:destroy, :new, :create]
  
  includes :user
  
  decorate_with Analyzable::TransactionDecorator
  
  index title: 'Transactions' do 
    selectable_column
    id_column
    column 'Transaction ID' do |transaction|
      transaction.transaction_key.to_s.truncate(9, omission: '...')
    end
    column :amount
    column "User's balance", :balance
    column 'Payer/Payee', :target_name
    column 'Category' do |transaction|
      transaction.category.titlecase
    end
    column 'User' do |transaction|
      link_to transaction.user.avatar_name, admin_user_path(transaction.user)
    end
    column 'Source' do |transaction|
      transaction.source_link
    end
    column 'Parent Transaction' do |transaction|
      if transaction.parent_transaction
        link_to transaction.parent_transaction_id, 
                admin_analyzable_transaction_path(transaction.parent_transaction)
      end
    end 
    column 'Splits' do |transaction|
      transaction.sub_transactions.size
    end 
    column 'Description' do |transaction|
      transaction.description.to_s.truncate(15, separator: ' ', omission: '...')
    end
    column :alert
    
    actions
    
  end
# See permitted parameters documentation:
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
