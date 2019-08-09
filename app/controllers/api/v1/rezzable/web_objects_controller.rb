# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      # Controller for terminal requests .
      class WebObjectsController < Api::V1::RezzableController
        ## Logic is all handled in Api::V1::RezzableController
        ## Just need to impliment the .response_data methods.

        private

        def response_data
          { api_key: @requesting_object.api_key }
        end
      end
    end
  end
end
