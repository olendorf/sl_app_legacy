# frozen_string_literal: true

module Api
  module V1
    # Controller for all SL api requests
    class ApiController < ApplicationController
      include Api::ExceptionHandler
      include Api::ResponseHandler

      skip_before_action :authenticate_user!
      before_action :load_requesting_object
      before_action :validate_package

      private

      # def pundit_user
      #   @requesting_object.user
      # end

      # rubocop:disable Style/MultilineIfModifier
      def validate_package
        raise(
          ActionController::BadRequest, t('errors.auth_time')
        ) unless (Time.now.to_i - auth_time).abs < 30
        raise(ActionController::BadRequest, t('errors.auth_digest')) unless auth_digest

        raise(
          ActionController::BadRequest, t('errors.auth_digest')
        ) unless auth_digest == create_digest
      end
      # rubocop:enable Style/MultilineIfModifier

      def auth_digest
        request.headers['HTTP_X_AUTH_DIGEST']
      end

      def auth_time
        return 0 unless request.headers['HTTP_X_AUTH_TIME']

        request.headers['HTTP_X_AUTH_TIME'].to_i
      end

      def create_digest
        Digest::SHA1.hexdigest(auth_time.to_s + api_key)
      end

      def api_key
        return Settings.default.api_key if action_name.downcase == 'create'

        @requesting_object.api_key
      end

      def load_requesting_object
        @requesting_object = Rezzable::WebObject.find_by_object_key(
          request.headers['HTTP_X_SECOND_LIFE_OBJECT_KEY']
        )
      end
    end
  end
end
