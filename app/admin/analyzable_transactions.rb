# frozen_string_literal: true

ActiveAdmin.register Analyzable::Transaction do
  menu label: 'Transactions', parent: 'Data'

  actions :all, except: %i[edit new create update destroy]

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
    column 'Source', &:source_link
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
                "Payment #{resource.amount.positive? ? 'From' : 'To'}: "\
                "#{resource.target_name}"
              } do
    attributes_table do
      if resource.amount.positive?
        row 'Payer' do |_transaction|
          "#{resource.target_name}: (#{resource.target_key})"
        end
      end
      unless resource.amount.positive?
        row 'Payee' do |_transaction|
          "#{resource.target_name}: (#{resource.target_key})"
        end
      end
      row 'Transaction ID', :transaction_key
      row :amount
      row :balance
      row :category
      row :description
      row :user do |transaction|
        link_to transaction.user.avatar_name, admin_user_path(transaction.user)
      end
      row :source, &:source_link
      if resource.parent_transaction
        row :parent_transaction do |resource|
          link_to resource.parent_transaction.id,
                  admin_analyzable_transaction_path(resource.parent_transaction)
        end
      end
      unless resource.sub_transactions.empty?
        row 'Splits' do |transaction|
          ul do
            transaction.sub_transactions.each do |splt|
              li class: 'list-unstyled' do
                link_to "#{splt.amount} -> #{splt.target_name}",
                        admin_analyzable_transaction_path(splt)
              end
            end
          end
        end
      end
      row :alert
    end
  end
end
