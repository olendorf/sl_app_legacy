# frozen_string_literal: true

module Analyzable
  # Model for inventory kept inside a server. Made it in Rezzable module, which doesn't
  # feel super duper right, but its not really an analyzable either.
  class Inventory < ApplicationRecord
    validates :inventory_name,  presence: true
    validates :inventory_name,  uniqueness: { scope: :server_id }
    validates :inventory_type,  presence: true
    validates :owner_perms,     presence: true
    validates :next_perms,      presence: true

    belongs_to :server, class_name: 'Rezzable::Server', counter_cache: :inventory_count

    PERMS = { copy: 0x00008000, modify: 0x0004000, transfer: 0x00002000 }.freeze

    enum inventory_type: {
      texture: 0,
      sound: 1,
      landmark: 3,
      clothing: 5,
      object: 6,
      notecard: 7,
      script: 10,
      body_part: 13,
      animation: 20,
      gesture: 21,
      setting: 56
    }

    # Some metaprogramming here to generate methods to determine
    # the perms of an inventory along the lines of owner_can_modify? or
    # next_can_transfer?
    %i[owner next].each do |who|
      PERMS.each do |perm, _value|
        define_method("#{who}_can_#{perm}?") do
          (send("#{who}_perms") & PERMS[perm]).positive?
        end
      end
    end
    
    def product
      product = self.server.user.products.find_by_product_name(self.inventory_name)
      return product if product
      product_alias = Analyzable::ProductAlias.where(
          product_id: self.server.user.products.map { |p| 
            p.id
          }
        ).find_by_alias_name(self.inventory_name)
      return product_alias.product if product_alias
      nil
    end
  end
end
