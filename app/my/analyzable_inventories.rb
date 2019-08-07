# frozen_string_literal: true

ActiveAdmin.register Analyzable::Inventory, namespace: :my do
  include ActiveAdmin::InventoryBehavior

  menu false

  decorate_with Analyzable::InventoryDecorator

  actions :all, except: %i[new create index]
  scope_to :current_user, association_method: :inventories

  show title: :inventory_name do
    attributes_table do
      row 'Name', &:inventory_name
      row 'Type', &:inventory_type
      row 'Owner Perms' do |inventory|
        inventory.pretty_perms(:owner)
      end
      row 'Next Perms' do |inventory|
        inventory.pretty_perms(:next)
      end
      row 'Server' do |inventory|
        link_to inventory.server.object_name, my_rezzable_server_path(inventory.server)
      end
      row :created_at
    end
  end

  permit_params :server_id

  form title: proc { "Edit #{resource.inventory_name}" } do |f|
    f.inputs do
      f.input :server, as: :select,
                       collection: resource.server.user.servers.map { |s|
                                     [s.object_name, s.id]
                                   }
    end
    f.actions do
      f.action :submit
      f.cancel_link(action: 'show')
    end
  end
end
