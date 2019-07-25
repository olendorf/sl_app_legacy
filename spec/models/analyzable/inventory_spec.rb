# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::Inventory, type: :model do
  describe 'validations' do
    subject { FactoryBot.create :inventory }
    it { should validate_presence_of(:inventory_name) }
    it { should validate_presence_of(:inventory_type) }
    it { should validate_presence_of(:owner_perms) }
    it { should validate_presence_of(:next_perms) }
    it { should validate_uniqueness_of(:inventory_name).scoped_to(:server_id) }
  end
  it { should belong_to(:server) }
  it {
    should define_enum_for(:inventory_type).with_values(
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
  
  let(:user) { FactoryBot.create :user }
  let(:server) { FactoryBot.create :server, user_id: user.id } 
  let(:inventory) { FactoryBot.create :inventory, server_id: server.id }
  
  describe 'product' do
    before(:each) { FactoryBot.create_list :product, 3, user_id: user.id }
    context 'inventory uses product name' do 
      it 'should return the product it is linked to' do
        product = FactoryBot.create :product, user_id: user.id, 
                                              product_name: inventory.inventory_name
        expect(inventory.product).to eq product
      end
    end 
    
    context 'product does not exist' do
      it 'should return nil' do 
        bad_inv = FactoryBot.create :inventory, server_id: server.id, inventory_name: 'not there'
        expect(bad_inv.product).to be_nil
      end
    end
    
    context 'inventory uses a product alias' do 
      it 'should get the product its is linked to' do 
        product = FactoryBot.create :product, user_id: user.id
        product.aliases << FactoryBot.create_list(:alias, 3)
        product.aliases << FactoryBot.create(:alias, 
                                                alias_name: inventory.inventory_name) 
        expect(inventory.product).to eq product
      end
    end
  end
  
  describe 'price' do 
  end
  describe 'perm masks' do
    %w[owner next].each do |who|
      Analyzable::Inventory::PERMS.each do |perm, value|
        describe "#{who}_can_#{perm}?" do
          it 'should return true when the when the mask is set' do
            inventory.send("#{who}_perms=", value)
            expect(inventory.send("#{who}_can_#{perm}?")).to be_truthy
          end

          it 'should return false wehn the mask is not set' do
            inventory.send("#{who}_perms=",
                           Analyzable::Inventory::PERMS.except(perm).values.sum)
            expect(inventory.send("#{who}_can_#{perm}?")).to be_falsey
          end
        end
      end
    end
  end
end
