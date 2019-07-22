# frozen_string_literal: true

ActiveAdmin.register Analyzable::Inventory do
  
  menu false
  
  decorate_with Analyzable::InventoryDecorator
  
  actions :all, except: %i[new create index]
  
    show title: :inventory_name do
    attributes_table do
      row 'Name' do |inventory|
        inventory.inventory_name
      end
      row 'Type' do |inventory|
        inventory.inventory_type
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
  
  
  # actions %i[edit update destroy, show]
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
    
    before_action :delete_inworld_inventory, only: [:destroy]
    
    def destroy
      destroy! do |format|
        flash.notice = "Inventory deleted."
        format.html redirect_back(fallback: admin_rezzable_servers_path)
      end
    end
    
    def delete_inworld_inventory
      if Rails.env.development?
        flash.alert = 'Inventory succssfully pretend derezzed in world'
        return
      end
      server = resource.server
      auth_time = Time.now.to_i
      auth_digest = Digest::SHA1.hexdigest(auth_time.to_s +
                                           server.web_object.api_key)
      url = "#{server.url}/inventory/(#{CGI.escape(resource.inventory_name)})"
      begin
        RestClient.delete url,
                          content_type: :json,
                          accept: :json,
                          'x-auth-digest' => auth_digest,
                          'x-auth-time' => auth_time
      rescue RestClient::ExceptionWithResponse => e
        flash[:error] = t('active_admin.inventory.delete.failure',
                          message: e.response)
      end
    end
  end
end
