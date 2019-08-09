# frozen_string_literal: true

ActiveAdmin.register User do
  menu priority: 2
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column 'Avatar Name' do |user|
      link_to user.avatar_name, admin_user_path(user)
    end
    column 'Role' do |user|
      user.role.capitalize
    end
    column :account_level
    column :expiration_date
    column :object_weight
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions
  end

  filter :avatar_name_contains, label: 'Avatar Name'
  filter :role, as: :check_boxes, collection: proc { User.roles }
  filter :account_level
  filter :expiration_date
  filter :object_weight

  show title: :avatar_name do
    attributes_table do
      row :avatar_name
      row :avatar_key
      row 'Role' do |user|
        user.role.capitalize
      end
      row :account_level
      row :object_weight
      row :expiration_date
      row :remember_created_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :created_at
      row :updated_at
    end
  end

  sidebar :splits, only: %i[show edit] do
    total = 0.0
    dl class: 'row' do
      resource.splits.each do |split|
        total += split.percent
        dt split.target_name
        dd "#{number_with_precision(split.percent * 100, precision: 0)}%"
      end
      dt 'Total'
      dd "#{number_with_precision(total * 100, precision: 0)}%"
    end
  end

  sidebar :managers, only: %i[show edit] do
    paginated_collection(
      resource.managers.page(
        params[:manager_page]
      ).per(10), param_name: 'manager_page'
    ) do
      table_for collection do
        column 'Manager', &:avatar_name
        column '' do |manager|
          link_to 'Delete', 
                  admin_listable_avatar_path(manager), 
                  id: "delete_manager_#{manager.id}",
                  class: "delete listable_avatar manager",
                  method: :delete
        end
      end
    end
  end

  permit_params :role, :account_level, :expiration_date,
                splits_attributes: %i[id target_name
                                      target_key percent _destroy]

  form title: proc { "Edit #{resource.avatar_name}" } do |f|
    f.inputs do
      f.input :role, include_blank: false
      f.input :account_level
      f.input :expiration_date, as: :datepicker
    end
    f.has_many :splits, heading: 'Splits',
                        allow_destroy: true do |s|
      s.input :target_name, label: 'Avatar Name'
      s.input :target_key, label: 'Avatar Key'
      s.input :percent
    end
    f.actions
  end
end
