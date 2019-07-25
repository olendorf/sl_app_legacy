# frozen_string_literal: true

module Rezzable
  # Model for simple one prim vendors
  class Vendor < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'
    
    def inventory
      begin 
        self.server.inventories.find_by_inventory_name(self.inventory_name)
      rescue
        nil
      end 
    end
    
    def price
      begin 
        inventory.price
      rescue 
        0
      end
    end
    
    # def price 
    #   self.server.inventories.find_by_inventory_name(self.inventory_name).product.price
    # end
  end
end
