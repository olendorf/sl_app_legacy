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
  
  let(:inventory) { FactoryBot.build :inventory }
  describe 'perm masks' do
    ['owner', 'next'].each do |who|
      Rezzable::Inventory::PERMS.each do |perm, value|
        describe "#{who}_can_#{perm}?" do 
          it "should return true when the when the mask is set" do 
            inventory.send("#{who}_perms=", value)
            expect(inventory.send("#{who}_can_#{perm}?")).to be_truthy
          end
          
          it 'should return false wehn the mask is not set' do 
            inventory.send("#{who}_perms=", Rezzable::Inventory::PERMS.except(perm).values.sum)
            expect(inventory.send("#{who}_can_#{perm}?")).to be_falsey
          end
        end
      end
    end
  end
end
