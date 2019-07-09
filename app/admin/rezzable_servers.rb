ActiveAdmin.register Rezzable::Server do
  include ActiveAdmin::RezzableBehavior
  
  menu label: 'Servers', parent: 'Objects'
  
  actions :all, except: %[new create]
  
  filter :web_object_object_name, as: :string, label: 'Object Name'
  
  index title: 'Servers' do
    selectable_column
    column 'Object Name', sortable: :object_name do |server|
      link_to server.object_name, admin_rezzable_server_path(server)
    end
    column 'Description' do |server|
      truncate(server.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region, &:slurl
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

end
