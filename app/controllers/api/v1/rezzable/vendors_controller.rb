# frozen_string_literal: true

class Api::V1::Rezzable::VendorsController < Api::V1::RezzableController
  def response_data
    {
      api_key: @requesting_object.api_key,
      price: @requesting_object.actable.price,
      image_key: @requesting_object.actable.image_key
    }
  end
end
