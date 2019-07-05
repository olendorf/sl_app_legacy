# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      # Controller for requests coming from in world controllers
      class ServersController < Api::V1::RezzableController
        private

        def response_data
          { api_key: @requesting_object.api_key }
        end
      end
    end
  end
end
