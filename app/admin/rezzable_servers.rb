ActiveAdmin.register Rezzable::Server do
  include ActiveAdmin::RezzableBehavior
  
  menu label: 'Servers', parent: 'Objects'
  
  actions :all, except: %[new create]
  
  decorate_with Rezzable::ServerDecorator
  
  index title: 'Servers' do
    selectable_column
    column 'Object Name', sortable: :object_name do |server|
      link_to server.object_name, admin_rezzable_server_path(server)
    end
    column 'Description' do |server|
      truncate(server.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region, &:slurl
    column :inventory_count
    column 'Owner', sortable: 'users.avatar_name' do |server|
      if server.user
        link_to server.user.avatar_name, admin_user_path(server.user)
      else
        'Orphan'
      end
    end
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
  filter :web_object_user_avatar_name, as: :string, label: 'Owner'
  filter :web_object_pinged_at, as: :date_range, label: 'Last Ping'
  filter :web_object_create_at, as: :date_range
  filter :inventory_count
  
  show title: :object_name do
    attributes_table do
      row :object_name do |server|
        link_to server.user.avatar_name, admin_user_path(server.user)
      end
      row :object_key
      row :description
      row 'Owner', sortable: 'users.avatar_name' do |server|
        if server.user
          link_to server.user.avatar_name, admin_user_path(server.user)
        else
          'Orphan'
        end
      end
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
          column :inventory_name
          column :inventory_type
          column 'Owner Perms' do |inventory|
            inventory.pretty_perms(:owner)
          end
          column 'Next Perms' do |inventory|
            inventory.pretty_perms(:next)
          end
        end
      end
    end
  end
  
  


end
