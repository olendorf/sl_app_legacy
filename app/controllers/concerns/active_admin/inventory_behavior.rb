# frozen_string_literal: true

module ActiveAdmin
  # Common behavior for Active Admin Rezzable Controllers.
  # Primarily for interacting with in world objecs but could be other things.
  module InventoryBehavior
    extend ActiveSupport::Concern
    def self.included(base)
      base.before_destroy do |_resource|
        delete_inworld_inventory
      end
      base.before_update do |_resource|
        handle_server_change
      end

      base.instance_eval do
        member_action :give, method: :post do
          unless Rails.env.development?
            begin
              auth_time = Time.now.to_i
              RestClient::Request.execute(
                url: resource.server.url + '/inventory/give',
                method: :post,
                payload: {
                  target_name: params['avatar_name'],
                  inventory_name: resource.inventory_name
                }.to_json,
                verify_ssl: false,
                headers: {
                  content_type: :json,
                  accept: :json,
                  verify_ssl: false,
                  params: {
                    auth_time: auth_time,
                    auth_digest: auth_digest(auth_time)
                  }
                }
              )
            rescue RestClient::ExceptionWithResponse => e
              flash[:error] = t('active_admin.inventory.give.failure',
                                inventory_name: resource.inventory_name,
                                error: "#{e.response}, " \
                                       "url: #{resource.server.url + '/inventory/give'}")
            end
          end
          flash.notice = "Inventory given to #{params['avatar_name']}"
          redirect_back(
            fallback_location: send("#{self.class.parent.name.downcase}_dashboard_path")
          )
        end
      end

      base.controller do
        def auth_digest(auth_time)
          if resource.server.actable_type
            Digest::SHA1.hexdigest(auth_time.to_s +
                                                   resource.server.web_object.api_key)
          else
            Digest::SHA1.hexdigest(auth_time.to_s + resource.server.api_key)
          end
        end

        # def request_url(path = '')
        #   auth_time = Time.now.to_i
        #   "#{resource.server.url}#{path}?auth_time=#{auth_time}" \
        #     "&auth_digest=#{auth_digest(auth_time)}"
        # end

        def destroy
          destroy! do |format|
            flash.notice = t('active_admin.inventory.destroy.success')
            format.html do
              redirect_back(
                fallback_location: send(
                  "#{self.class.parent.name.downcase}_rezzable_servers_path"
                )
              )
            end
          end
        end

        def update
          update! do |format|
            flash.notice = t('active_admin.inventory.give.success')
            format.html do
              redirect_back(
                fallback_location: send(
                  "#{self.class.parent.name.downcase}_analyzable_inventory_path",
                  resource
                )
              )
            end
          end
        end

        def handle_server_change
          target_server = Rezzable::Server.find(
            params['analyzable_inventory']['server_id'].to_i
          )
          send_inventory(target_server.object_key)
        end

        def send_inventory(target_key)
          unless Rails.env.development?
            begin
              auth_time = Time.now.to_i
              RestClient::Request.execute(
                url: resource.server.url + '/inventory/server',
                method: :post,
                payload: {
                  target_key: target_key,
                  inventory_name: resource.inventory_name
                }.to_json,
                verify_ssl: false,
                headers: {
                  content_type: :json,
                  accept: :json,
                  verify_ssl: false,
                  params: {
                    auth_time: auth_time,
                    auth_digest: auth_digest(auth_time)
                  }
                }
              )
            rescue RestClient::ExceptionWithResponse => e
              flash[:error] = t('active_admin.inventory.give.failure',
                                inventory_name: resource.inventory_name,
                                error: e.response)
            end
          end
        end

        def delete_inworld_inventory
          unless Rails.env.development?
            begin
              auth_time = Time.now.to_i
              RestClient::Request.execute(
                url: resource.server.url +
                    "/inventory/#{CGI.escape(resource.inventory_name)}",
                method: :delete,
                verify_ssl: false,
                headers: {
                  content_type: :json,
                  accept: :json,
                  verify_ssl: false,
                  params: {
                    auth_time: auth_time,
                    auth_digest: auth_digest(auth_time)
                  }
                }
              )
            rescue RestClient::ExceptionWithResponse => e
              flash[:error] = t('active_admin.inventory.delete.failure',
                                message: e.response)
            end
          end
        end
      end
    end
  end
end
