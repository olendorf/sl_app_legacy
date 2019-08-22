# frozen_string_literal: true

ActiveAdmin.register Analyzable::Inventory do
  include ActiveAdmin::InventoryBehavior

  menu false

  decorate_with Analyzable::InventoryDecorator

  actions :all, except: %i[new create index]

  show title: :inventory_name do
    attributes_table do
      row 'Name', &:inventory_name
      row 'Type', &:inventory_type
      row 'Owner' do |inventory|
        link_to inventory.server.user.avatar_name, admin_user_path(inventory.server.user)
      end
      row 'Owner Perms' do |inventory|
        inventory.pretty_perms(:owner)
      end
      row 'Next Perms' do |inventory|
        inventory.pretty_perms(:next)
      end
      row 'Server' do |inventory|
        link_to inventory.server.object_name, admin_rezzable_server_path(inventory.server)
      end
      row :created_at
    end
  end

  sidebar :give_inventory, only: %i[show edit] do
  end

  sidebar :give_inventory, partial: 'give_inventory_form', only: %i[show edit]

  permit_params :server_id

  form title: proc { "Edit #{resource.inventory_name}" } do |f|
    f.inputs do
      f.input :server, as: :select,
                       include_blank: false,
                       collection: resource.server.user.servers.map { |s|
                         [s.object_name, s.id]
                       }
    end
    f.actions do
      f.action :submit
      f.cancel_link(action: 'show')
    end
  end

  # member_action :give, method: :post do
  #   redirect_back notice: "Given!"
  # end
end
