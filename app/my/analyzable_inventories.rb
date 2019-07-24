# frozen_string_literal: true

ActiveAdmin.register Analyzable::Inventory, namespace: :my do
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
    before_action :handle_server_change, only: [:update]

    def destroy
      destroy! do |format|
        flash.notice = t('active_admin.inventory.destroy.success')
        format.html { redirect_back(fallback_location: my_rezzable_servers_path) }
      end
    end
    
    def update
      update! do |format|
        flash.notice = t('active_admin.inventory.give.success')
        format.html { 
          redirect_back(fallback_location: my_analyzable_inventory_path(resource)) 
        }
      end
    end 
    

    def handle_server_change
      target_server = Rezzable::Server.find(
        params['analyzable_inventory']['server_id'].to_i
      )
      send_inventory(target_server.object_key)
    end

    # rubocop:disable Style/GuardClause, Metrics/MethodLength, Metrics/AbcSize
    def send_inventory(target_key)
      server = resource.server

      begin
        unless Rails.env.development?
          auth_time = Time.now.to_i
          auth_digest = Digest::SHA1.hexdigest(auth_time.to_s +
                                               server.web_object.api_key)
          url = resource.server.url + '/inventory/'
          params = { target_key: target_key, inventory_name: resource.inventory_name }
          RestClient.post url, params.to_json,
                          content_type: :json,
                          accept: :json,
                          'x-auth-digest' => auth_digest,
                          'x-auth-time' => auth_time
        end
      rescue RestClient::ExceptionWithResponse => e
        flash[:error] << t('active_admin.inventory.give.failure',
                           inventory_name: resource.inventory_name, error: e.response)
      end
    end

    def delete_inworld_inventory
      unless Rails.env.development?
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

    # rubocop:enable Style/GuardClause, Metrics/MethodLength, Metrics/AbcSize
  end
end
