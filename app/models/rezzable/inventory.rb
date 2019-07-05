class Rezzable::Inventory < ApplicationRecord
  belongs_to :server, class_name: 'Rezzable::Server', counter_cache: :inventory_count
  
  PERMS = {copy: 0x00008000, modify: 0x0004000, transfer: 0x00002000}
  
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

  [:owner, :next].each do |who|
    PERMS.each do |perm, value|
      define_method("#{who}_can_#{perm}?") do 
        (send("#{who}_perms") & PERMS[perm]) > 0
      end
    end
  end
end
