# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Vendor, type: :model do
  it { should respond_to :web_object }

  let(:user) { FactoryBot.create :active_user }
  let(:server) do
    server = FactoryBot.build :server, user_id: user.id
    server.save
    server.inventories << inventory
    server
  end

  let(:product) { FactoryBot.create :product, user_id: user.id }

  let(:inventory) { FactoryBot.create :inventory, inventory_name: product.product_name }

  let(:vendor) do
    vendor = FactoryBot.build :vendor, user_id: user.id, inventory_name: inventory.inventory_name
    vendor.save
    server.clients << vendor
    vendor
  end
  it 'should have weight of 1' do
    expect(vendor.weight).to eq 1
  end

  # it 'should get the price' do
  #   user = FactoryBot.create :user
  #   server = FactoryBot.create :server, user_id: user.id
  #   server.clients << vendor
  #   inventory = FactoryBot.create :inventory
  #   product = FactoryBot.create :product, product_name: inventory.inventory_name, user_id: user.id
  #   vendor.inventory_name = inventory.inventory_name
  #   server.inventories << inventory
  #   expect(vendor.price).to eq product.price
  # end

  it 'should get the inventory' do
    expect(vendor.inventory).to eq inventory
  end

  it 'should get the price' do
    expect(vendor.price).to eq product.price
  end
end
