# frozen_string_literal: true

ActiveAdmin.register Rezzable::Server, namespace: :my do
  include ActiveAdmin::RezzableBehavior

  menu label: 'Servers', parent: 'Objects'

  actions :all, except: %i[new create]

  scope_to :current_user, association_method: :servers

  decorate_with Rezzable::ServerDecorator

  index title: 'Servers' do
    selectable_column
    column 'Object Name', sortable: :object_name do |server|
      link_to server.object_name, my_rezzable_server_path(server)
    end
    column 'Description' do |server|
      truncate(server.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region, &:slurl
    column :inventory_count
    column 'Last Ping', sortable: :pinged_at do |server|
      if server.active?
        status_tag 'active', label: time_ago_in_words(server.pinged_at)
      else
        status_tag 'inactive', label: time_ago_in_words(server.pinged_at)
      end
    end
    column :created_at, sortable: :created_at
    actions
  end

  filter :web_object_object_name, as: :string, label: 'Object Name'
  filter :web_object_description, as: :string, label: 'Description'
  filter :web_object_pinged_at, as: :date_range, label: 'Last Ping'
  filter :web_object_create_at, as: :date_range, label: 'Created At'
  filter :inventory_count

  show title: :object_name do
    attributes_table do
      row :object_name
      row :object_key
      row :description
      row :location, &:slurl
      row :created_at
      row :updated_at
      row :pinged_at
      row :status do |server|
        if server.active?
          status_tag 'active', label: 'Active'
        else
          status_tag 'inactive', label: 'Inactive'
        end
      end
    end

    panel 'Inventory' do
      paginated_collection(
        resource.inventories.page(
          params[:inventory_page]
        ).per(20), param_name: 'inventory_page'
      ) do
        table_for collection.decorate do
          column 'Name' do |inventory|
            link_to inventory.inventory_name, my_analyzable_inventory_path(inventory)
          end
          column 'Type', :inventory_type
          column 'Owner Perms' do |inventory|
            inventory.pretty_perms(:owner)
          end
          column 'Next Perms' do |inventory|
            inventory.pretty_perms(:next)
          end
          column '' do |inventory|
            span class: 'table_actions' do
              "#{link_to('View', my_analyzable_inventory_path(inventory),
                         class: 'view_link member_link')}
              #{link_to('Edit', edit_my_analyzable_inventory_path(inventory),
                        class: 'edit_link member_link')}
              #{link_to('Delete', my_analyzable_inventory_path(inventory),
                        class: 'delete_link member_link',
                        method: :delete,
                        confirm: 'Are you sure you want to delete this?')}".html_safe
            end
          end
        end
      end
    end
  end

  permit_params :object_name, :description,
                inventories_attributes: %i[id _destroy]

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name
      f.input :description
    end
    f.has_many :inventories, heading: 'Inventory',
                             new_record: false,
                             allow_destroy: true do |i|
      i.input :inventory_name, input_html: { disabled: true }
    end
    f.actions
  end

  controller do
    # def scoped_collection
    #   super.includes :user
    # end

    # def update_web_object(resource)
    #   puts "would delete inventories here"
    #   super
    # end
  end
end
