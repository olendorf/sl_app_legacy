# frozen_string_literal: true

module Analyzable
  # Class to provide multiple names to products. Allows users to have multiple
  # inventory names and different' product names on marketplace
  class ProductAlias < ApplicationRecord
    belongs_to :product, class_name: 'Analyzable::Product'
  end
end
