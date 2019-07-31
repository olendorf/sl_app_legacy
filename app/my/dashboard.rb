# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard', namespace: :my do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel 'Recent Transactions' do
          table_for current_user.transactions.last(20).reverse do
            column 'Payee/Payer', :target_name
            column :amount
            column :balance
            column :created_at
            column :category
          end
        end
      end

      column do
        panel 'Info' do
          para 'Welcome to ActiveAdmin.'
        end
      end
    end
  end
  
  sidebar :splits, only: %i[index] do
    total = 0.0
    dl class: 'row' do
      current_user.splits.each do |split|
        total += split.percent
        dt split.target_name
        dd "#{number_with_precision(split.percent * 100, precision: 0)}%"
      end
      dt 'Total'
      dd "#{number_with_precision(total * 100, precision: 0)}%"
    end
    
    hr
    link_to 'Edit Splits', edit_my_user_path(current_user)
  end

end
