# frozen_string_literal: true

module ActiveAdmin
  # Common behavior for Active Admin Rezzable Controllers.
  # Primarily for interacting with in world objecs but could be other things.
  module RezzableBehavior
    extend ActiveSupport::Concern

    def self.included(base)
      base.before_destroy do |resource|
        derez_web_object(resource)
      end

      base.before_update do |resource|
        update_web_object(resource)
      end

      base.controller do
        def derez_web_object(resource)
          if Rails.env.development?
            flash.alert = 'Object succssfully pretend derezzed in world'
            return
          end
          auth_time = Time.now.to_i
          auth_digest = Digest::SHA1.hexdigest(auth_time.to_s + resource.rezzable.api_key)
          begin 
            RestClient.delete resource.url,
                              content_type: :json,
                              accept: :json,
                              'x-auth-digest' => auth_digest,
                              'x-auth-time' => auth_time
          rescue RestClient::ExceptionWithResponse => e
            flash[:error] = t('active_admin.web_object.delete.failure',
                              message: e.response)
          end 
        end

        def update_web_object(resource)
          if Rails.env.development?
            flash.alert = 'Object succssfully pretend updated in world'
            return
          end
          auth_time = Time.now.to_i
          auth_digest = Digest::SHA1.hexdigest(auth_time.to_s + resource.rezzable.api_key)
          begin 
            params['rezzable_terminal'].each do |att, val|
              RestClient.put  resource.url,
                              { att => val }.to_json,
                              content_type: :json,
                              accept: :json,
                              'x-auth-digest' => auth_digest,
                              'x-auth-time' => auth_time
            end 
          rescue RestClient::ExceptionWithResponse => e
            flash[:error] = t('active_admin.web_object.delete.failure',
                              message: e.response)
          end 
        end
      end
    end
  end
end
