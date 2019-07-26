# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      # Handles requests about inworld Vendors
      class VendorsController < Api::V1::RezzableController
        def response_data
          {
            api_key: @requesting_object.api_key,
            price: @requesting_object.actable.price,
            image_key: @requesting_object.actable.image_key
          }
        end
      end
    end
  end
end
