ActiveAdmin.register Rezzable::Terminal do
  menu label: 'Terminals', parent: 'Rezzable'
  
  actions :all, except: [:new, :create]
  
  decorate_with Rezzable::TerminalDecorator
  
  index title: 'Terminals' do
    selectable_column
    column 'Object Name' do |terminal|
      link_to terminal.object_name, admin_rezzable_terminal_path(terminal)
    end
    column 'Description' do |terminal|
      truncate(terminal.description, length: 10, separator: ' ')
    end
    column 'Location' do |terminal|
      terminal.slurl
    end
    column 'Owner' do |terminal|
      link_to terminal.user.avatar_name, admin_user_path(terminal.user)
    end
    column 'Last Ping', :pinged_at
    column :created_at
    actions
  end
  
  filter :rezzable_object_name, as: :string, label: 'Object Name'
  filter :rezzable_description, as: :string, label: 'Description'
  filter :rezzable_user_avatar_name, as: :string, label: 'Owner'
  filter :rezzable_pinged_at, as: :date_range, label: 'Last Ping'
  filter :rezzable_create_at, as: :date_range
  
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
