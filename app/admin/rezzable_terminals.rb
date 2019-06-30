# frozen_string_literal: true

ActiveAdmin.register Rezzable::Terminal do
  include ActiveAdmin::RezzableBehavior

  menu label: 'Terminals', parent: 'Rezzable'

  actions :all, except: %i[new create]

  decorate_with Rezzable::TerminalDecorator

  index title: 'Terminals' do
    selectable_column
    column 'Object Name', sortable: :object_name do |terminal|
      link_to terminal.object_name, admin_rezzable_terminal_path(terminal)
    end
    column 'Description' do |terminal|
      truncate(terminal.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region, &:slurl
    column 'Owner', sortable: 'users.avatar_name' do |terminal|
      if terminal.user
        link_to terminal.user.avatar_name, admin_user_path(terminal.user)
      else
        'Orphan'
      end
    end
    column 'Last Ping', sortable: :pinged_at do |terminal|
      if terminal.active?
        status_tag 'active', label: time_ago_in_words(terminal.pinged_at)
      else
        status_tag 'inactive', label: time_ago_in_words(terminal.pinged_at)
      end
    end
    column :created_at, sortable: :created_at
    actions
  end

  filter :rezzable_object_name, as: :string, label: 'Object Name'
  filter :rezzable_description, as: :string, label: 'Description'
  filter :rezzable_user_avatar_name, as: :string, label: 'Owner'
  filter :rezzable_pinged_at, as: :date_range, label: 'Last Ping'
  filter :rezzable_create_at, as: :date_range

  show title: :object_name do
    attributes_table do
      row :object_name do |terminal|
        link_to terminal.user.avatar_name, admin_user_path(terminal.user)
      end
      row :object_key
      row :description
      row 'Owner', sortable: 'users.avatar_name' do |terminal|
        if terminal.user
          link_to terminal.user.avatar_name, admin_user_path(terminal.user)
        else
          'Orphan'
        end
      end
      row :location, &:slurl
      row :created_at
      row :updated_at
      row :pinged_at
      row :status do |terminal|
        if terminal.active?
          status_tag 'active', label: 'Active'
        else
          status_tag 'inactive', label: 'Inactive'
        end
      end
    end
  end
  
  sidebar :splits, only: [:show, :edit] do
    dl class: 'row' do 
      resource.splits.each do |split|
        dt split.target_name
        dd "#{number_with_precision(split.percent, precision: 2)}%"
      end
    end
  end

  permit_params :object_name, :description,
                splits_attributes: [:id, :target_name, 
                                    :target_key, :percent, :_destroy]

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name
      f.input :description
    end
    f.has_many :splits, heading: 'Splits', 
                        allow_destroy: true do |s|
      s.input :target_name, label: 'Avatar Name'
      s.input :target_key, label: 'Avatar Key'
      s.input :percent
    end
    f.actions
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
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

  controller do

    def scoped_collection
      super.includes :user
    end

  end
end
