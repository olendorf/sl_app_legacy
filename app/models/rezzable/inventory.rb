class Rezzable::Inventory < ApplicationRecord
  belongs_to :server, class_name: 'Rezzable::Server', counter_cache: :inventory_count
  
  enum inventory_type: {            texture: 0,
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
end
