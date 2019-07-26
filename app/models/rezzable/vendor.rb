# frozen_string_literal: true

module Rezzable
  # Model for simple one prim vendors
  class Vendor < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'

    def inventory
      server.inventories.find_by_inventory_name(inventory_name)
    rescue StandardError
      nil
    end

    def price
      inventory.price
    rescue StandardError
      0
    end

    # def price
    #   self.server.inventories.find_by_inventory_name(self.inventory_name).product.price
    # end
  end
end
