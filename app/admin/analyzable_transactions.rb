ActiveAdmin.register Analyzable::Transaction do
  
  menu label: 'Transactions', parent: 'Data'
  
  actions :all, except: [:destroy]
  
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
    column :created_at
    column :alert
    
    actions
    
  end
  
  filter :transaction_key, label: 'Transaction ID'
  filter :user_avatar_name_contains, label: 'User Name'
  filter :amount
  filter :category, as: :check_boxes, 
                    collection: proc { Analyzable::Transaction.categories }
  filter :description
  filter :alert
  filter :created_at
  
  show title: proc { 
    "#{resource.amount.positive? ? "Payer" : "Payee"}: #{resource.target_name}"} do 
      
    attributes_table do 
      row 'Payer' do |transaction|
        "#{resource.target_name}: (#{resource.target_key})"
      end if resource.amount.positive?
      row 'Payee' do |transaction|
        "#{resource.target_name}: (#{resource.target_key})"
      end unless resource.amount.positive?
      row 'Transaction ID', :transaction_key
      row :amount
      row :balance
      row :category
      row :description
      row :user do |transaction|
        link_to transaction.user.avatar_name, admin_user_path(transaction.user)
      end 
      row :source do |transaction|
        transaction.source_link
      end
      row :parent_transaction do |resource|
        link_to resource.parent_transaction.id, 
                admin_analyzable_transaction_path(resource.parent_transaction)
      end if resource.parent_transaction
      row 'Splits' do |transaction|
        ul do 
          transaction.sub_transactions.each do |splt|
            li class: 'list-unstyled' do 
              link_to "#{splt.amount} -> #{splt.target_name}", admin_analyzable_transaction_path(splt)
            end
          end 
        end
      end if resource.sub_transactions.size > 0
      row :alert
      
    end
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
