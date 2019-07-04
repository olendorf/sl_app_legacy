# frozen_string_literal: true

module Api
  module V1
    # Controller for SL API requests to User
    class TestController < Api::V1::ApiController
      skip_before_action :load_requesting_object, except: [:create]
      skip_before_action :validate_package

      skip_after_action :verify_authorized
      def show
        render json: {message: 'OK'}
      end
    end
  end
end
