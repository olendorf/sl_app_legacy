# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'inventory management', type: :request do
  let(:active_user) { FactoryBot.create :active_user }
  let(:server) { FactoryBot.create :server, user_id: active_user.id }
  let(:inventory) do 
    inventory = FactoryBot.build :inventory
    server.inventories << inventory
    inventory
  end
  
  describe 'create' do 
    let(:path) { api_analyzable_inventories_path }
    context 'inventory does not exist' do 
      let(:atts) { FactoryBot.attributes_for :inventory }
      it 'returns created status' do 
        post path, params: atts.to_json, headers: headers(server)
        expect(response.status).to eq 201
      end
    end 
    
    context 'inventory does exist' do 
      let(:atts) {
        inventory.attributes.except('id', 'server_id', 'created_at', 'updated_at') 
      }
      it 'returns OK status' do 
        post path, params: atts.to_json, headers: headers(server)
        expect(response.status).to eq 200
      end
    end
  end
  
  describe 'show' do 
    let(:path) { api_analyzable_inventory_path(inventory.inventory_name) }
    
    it 'should return ok status' do
      get path, headers: headers(server)
      expect(response.status).to eq 200
    end
    
    it 'should return the data' do 
      get path, headers: headers(server)
      expect(JSON.parse(response.body)['data']).to eq(
          {
            'created_at' => inventory.created_at.to_s(:long)
          }
        )
    end
  end
  
  describe 'destroy' do
    before(:each) do 
      server.inventories << FactoryBot.create_list(:inventory, 5)
    end
    
    context 'one inventory' do 
      let(:path) do
        api_analyzable_inventory_path(inventory.inventory_name)
      end
      before(:each) { delete path, headers: headers(server) }
      
      it 'should return ok status' do
        expect(response.status).to eq 200
      end
      
      it 'should delete the object' do 
        expect(Analyzable::Inventory.exists?(inventory.id)).to be_falsey
      end
    end
    
    context 'all inventory' do 
      let(:path) { api_analyzable_inventory_path('all') }
      before(:each) { delete path, headers: headers(server) }
      
      it 'should return ok status' do 
        expect(response.status).to eq 200
      end 
      
      it 'should delete all the inventories' do 
        expect(server.inventories.size).to eq 0
      end
    end
  end
end
