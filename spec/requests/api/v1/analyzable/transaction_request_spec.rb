# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transaction requestst', type: :request do
  
  let(:user) { FactoryBot.create :user, account_level: 1, expiration_date: 1.week.from_now }
  let(:web_object) { FactoryBot.create :web_object, user_id: user.id }
  let(:path) { api_analyzable_transactions_path }
  let(:atts) { FactoryBot.attributes_for :transaction }
  
  describe 'making a simple transaction request' do 
    it 'should return created status' do 
      post path, params: atts, headers: headers(web_object)
      expect(response.status).to eq 201
    end
  
    it 'should create a transaction' do 
      expect{
        post path, params: atts, headers: headers(web_object)
      }.to change(Analyzable::Transaction, :count).by(1)
    end
    
    it 'should update the users balance' do 
      post path, params: atts, headers: headers(web_object)
      user.reload
      expect(user.balance).to eq atts[:amount]
    end
    
  end
  
  
end 