ActiveAdmin.register Rezzable::Terminal do
  menu label: 'Terminals', parent: 'Rezzable'
  
  actions :all, except: [:new, :create]
  
  decorate_with Rezzable::TerminalDecorator
  
  index title: 'Terminals' do
    selectable_column
    column 'Object Name', sortable: :object_name do |terminal|
      link_to terminal.object_name, admin_rezzable_terminal_path(terminal)
    end
    column 'Description' do |terminal|
      truncate(terminal.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region do |terminal|
      terminal.slurl
    end
    column 'Owner', sortable: 'users.avatar_name' do |terminal|
      link_to terminal.user.avatar_name, admin_user_path(terminal.user)
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
      row :location do |terminal|
        terminal.slurl
      end 
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
  
  permit_params :object_name, :description
  
  form title: proc { "Edit #{resource.object_name}" } do |f|
    inputs do 
      input :object_name
      input :description
    end
    actions
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
