# frozen_string_literal: true

module Api
  module V1
    # Controller for SL API requests to User
    class TestController < Api::V1::ApiController
      skip_before_action :load_requesting_object, except: [:create]
      skip_before_action :validate_package

      skip_after_action :verify_authorized
      def show
        keys = request.headers.to_h.keys.grep /http_x/i
        headers = request.headers.to_h.with_indifferent_access
        auth_key = request.headers.to_h.keys.grep(/auth_digest/i).first
        time_key = request.headers.to_h.keys.grep(/auth_time/i).first
        sent_headers = headers.slice(*keys)
        sent_headers[auth_key] = request.headers[auth_key]
        sent_headers[time_key] = request.headers[time_key]
        render json: { message: 'OK', headers: request.headers.to_h.keys }
      end
    end
  end
end
