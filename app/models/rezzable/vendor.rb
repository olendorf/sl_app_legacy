# frozen_string_literal: true

module Rezzable
  # Model for simple one prim vendors
  class Vendor < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'

    has_many :splits, as: :splittable,
                      class_name: 'Analyzable::Split',
                      dependent: :destroy

    accepts_nested_attributes_for :splits, allow_destroy: true

    def inventory
      server.inventories.find_by_inventory_name(inventory_name)
    rescue StandardError
      nil
    end

    def self.weight
      Settings.web_object.vendor.weight
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
