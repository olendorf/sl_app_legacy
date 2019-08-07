# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vendor management', type: :request do
  it_should_behave_like 'a user object API', :vendor

  let(:user) { FactoryBot.create :active_user }
  let(:server) { FactoryBot.create :server, user_id: user.id }
  let(:inventory) { FactoryBot.create :inventory, server_id: server.id }
  let(:vendor) do
    FactoryBot.create :vendor, user_id: user.id,
                               server_id: server.id,
                               inventory_name: inventory.inventory_name
  end

  describe 'GET' do
    let(:path) { api_rezzable_vendor_path(vendor.object_key) }
    it 'returns the correct data in show' do
      product = FactoryBot.create :product, user_id: user.id,
                                            product_name: inventory.inventory_name
      get path, headers: headers(vendor)
      expect(JSON.parse(response.body)['data']).to include(
        'api_key' => vendor.api_key,
        'price' => product.price,
        'image_key' => vendor.image_key
      )
    end
  end
end
