# frozen_string_literal: true

module Api
  module V1
    # Shared funcionality for all analyzable controllers
    class AnalyzableController < Api::V1::ApiController
      skip_before_action :load_requesting_object, except: [:create]
      prepend_before_action :load_requesting_object

      def api_key
        @requesting_object.api_key
      end
    end
  end
end
