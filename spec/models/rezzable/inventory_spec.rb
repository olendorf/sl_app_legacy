require 'rails_helper'

RSpec.describe Rezzable::Inventory, type: :model do
  it { should belong_to(:server) }
  it { should define_enum_for(:inventory_type).with_values(
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
          )
  }
end
