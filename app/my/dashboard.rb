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
end
