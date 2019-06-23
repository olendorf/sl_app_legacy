# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    column :avatar_name
    column :role
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
      row :role
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

  permit_params :role, :account_level, :expiration_date

  form title: proc { "Edit #{resource.avatar_name}" } do |f|
    f.inputs do
      f.input :role, include_blank: false
      f.input :account_level
      f.input :expiration_date, as: :datepicker,
                                datepicker_options: {
                                  min_date: Time.now,
                                  defaultDate: resource.expiration_date,
                                  max_date: '1Y'
                                }
    end
    f.actions
  end
end
