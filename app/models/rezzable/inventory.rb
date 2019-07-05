# frozen_string_literal: true

module Rezzable
  # Model for inventory kept inside a server. Made it in Rezzable module, which doesn't
  # feel super duper right, but its not really an analyzable either.
  class Inventory < ApplicationRecord
    
    validates :inventory_name, uniqueness: {scope: :server_id}
    
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
  end
end
