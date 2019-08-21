# frozen_string_literal: true

module ActiveAdmin
  # Common behavior for Active Admin Rezzable Controllers.
  # Primarily for interacting with in world objecs but could be other things.
  module RezzableBehavior
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/PerceivedComplexity
    def self.included(base)
      base.before_destroy do |resource|
        derez_web_object(resource)
      end

      base.before_update do |resource|
        update_web_object(resource)
      end
      base.controller do
        def auth_digest(auth_time)
          if resource.actable_type
            Digest::SHA1.hexdigest(auth_time.to_s +
                                                   resource.web_object.api_key)
          else
            Digest::SHA1.hexdigest(auth_time.to_s + resource.api_key)
          end
        end

        def request_url(path = '')
          auth_time = Time.now.to_i
          "#{resource.url}#{path}?auth_time=#{auth_time}" \
            "&auth_digest=#{auth_digest(auth_time)}"
        end

        def derez_web_object(_resource)
          if Rails.env.development?
            flash.alert = 'Object succssfully pretend derezzed in world'
            return
          end
          auth_time = Time.now.to_i
          # auth_digest = auth_digest

          begin
            RestClient.delete request_url,
                              content_type: :json,
                              accept: :json,
                              verify_ssl: false,
                              headers: { params: {
                                auth_time: auth_time,
                                auth_digest: auth_digest(auth_time)
                              } }
          rescue RestClient::ExceptionWithResponse => e
            flash[:error] = t('active_admin.web_object.delete.failure',
                              message: e.response)
          end
        end

        def update_web_object(_resource)
          # if Rails.env.development?
          #   flash.alert = 'Object succssfully pretend updated in world'
          #   return
          # end
          # auth_digest = auth_digest

          params[controller_name.singularize].each do |att, val|
            if att == 'inventories_attributes'
              handle_inventories val
            else
              unless Rails.env.development?
                RestClient.put  request_url,
                                { att => val }.to_json,
                                content_type: :json,
                                accept: :json
                # verify_ssl: false,
              end
            end
          end
        rescue RestClient::ExceptionWithResponse => e
          flash[:error] = t('active_admin.web_object.update.failure',
                            message: e.response)
        end

        def handle_inventories(nested_atts)
          nested_atts.each do |_key, atts|
            next unless atts['_destroy'].to_i.positive?

            inventory = resource.inventories.find(atts['id'].to_i)
            begin
              unless Rails.env.development?

                RestClient.delete request_url(
                  '/inventory/' + CGI.escape(inventory.inventory_name)
                ),
                                  content_type: :json,
                                  accept: :json,
                                  verify_ssl: false
              end
            rescue StandardError
              flash[:error] << t('active_admin.inventory.delete.failure',
                                 inventory_name: inventory.inventory_name)
            end
          end
        end
      end
    end

    # rubocop:enable Metrics/PerceivedComplexity
  end
end
