# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'transaction requestst', type: :request do
  let(:user) do
    FactoryBot.create :user, account_level: 1,
                             expiration_date: 1.week.from_now
  end
  let(:web_object) { FactoryBot.create :web_object, user_id: user.id }
  let(:path) { api_analyzable_transactions_path }
  let(:atts) { FactoryBot.attributes_for :transaction }

  describe 'making a simple transaction request' do
    it 'should return created status' do
      post path, params: atts.to_json, headers: headers(web_object)
      expect(response.status).to eq 201
    end

    it 'should create a transaction' do
      expect do
        post path, params: atts.to_json, headers: headers(web_object)
      end.to change(Analyzable::Transaction, :count).by(1)
    end

    it 'should update the users balance' do
      post path, params: atts.to_json, headers: headers(web_object)
      user.reload
      expect(user.balance).to eq atts[:amount]
    end
  end

  describe 'making a transaction with splits' do
    let(:owner) do
      owner = FactoryBot.create :owner
      owner.splits << FactoryBot.build(:split, percent: 0.1)
      owner
    end
    let(:terminal) do
      terminal = FactoryBot.create :terminal, user_id: owner.id
      terminal.splits << FactoryBot.build(:split, percent: 0.15)
      terminal.splits << FactoryBot.build(:split, percent: 0.2)
      terminal
    end
    before(:each) { atts[:amount] = 1000 }

    it 'should return created status' do
      post path, params: atts.to_json, headers: headers(terminal)
      owner.reload
      expect(response.status).to eq 201
    end

    it 'should create a transaction for each split and the initial transaction' do
      expect do
        post path, params: atts.to_json, headers: headers(terminal)
      end.to change(owner.transactions, :count).by(4)
    end

    it 'should have the correct balance' do
      post path, params: atts.to_json, headers: headers(terminal)
      owner.reload
      expect(owner.balance).to eq 550
    end

    it 'should add the splits to the transanction sub_transactions' do
      post path, params: atts.to_json, headers: headers(terminal)
      owner.reload
      expect(owner.transactions[-4].sub_transactions.count).to eq 3
    end
  end
end
