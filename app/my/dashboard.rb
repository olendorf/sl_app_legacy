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

  sidebar :managers, only: %i[index] do
    paginated_collection(
      current_user.managers.page(
        params[:manager_page]
      ).per(10), param_name: 'manager_page'
    ) do
      table_for collection do
        column 'Manager', &:avatar_name
        column '' do |manager|
          link_to 'Delete',
                  my_listable_avatar_path(manager),
                  id: "delete_manager_#{manager.id}",
                  class: 'delete listable_avatar manager',
                  method: :delete
        end
      end
    end
  end
end
