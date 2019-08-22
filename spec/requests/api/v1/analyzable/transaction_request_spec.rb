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
  let(:uri_regex) do
    %r{\Ahttps:\/\/sim3015.aditi.lindenlab.com:12043\/cap\/[-a-f0-9]{36}\/avatar\/pay\?
       auth_digest=[a-f0-9]+&auth_time=[0-9]+\z}x
  end
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

    # body: %r{"{\"amount\":[-0-9]+,\"target_key\":\"[-a-f0-9]{36}\"}"}x
    context 'successull request' do
      before(:each) do
        stub_request(:post, uri_regex)
          .with(
            body: /\S*/
          ).to_return(status: 201, body: '', headers: {})
      end
      context 'with a positive amount' do
        before(:each) { atts[:amount] = 1000 }

        it 'should return created status' do
          post path, params: atts.to_json, headers: headers(terminal)
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

      context 'with a negative amount' do
        before(:each) { atts[:amount] = -1000 }
        it 'should return created status' do
          post path, params: atts.to_json, headers: headers(terminal)
          expect(response.status).to eq 201
        end

        it 'should only create one transaction' do
          expect do
            post path, params: atts.to_json, headers: headers(terminal)
          end.to change(owner.transactions, :count).by(1)
        end
      end
    end

    context 'unsuccessful payment request' do
      before(:each) { atts[:amount] = 1000 }
      before(:each) do
        stub_request(:post, uri_regex)
          .with(
            body: /\S*/
          )
          .to_return(status: 400, body: '', headers: {}).then
          .to_return(status: 201, body: '', headers: {}).then
          .to_return(status: 201, body: '', headers: {})
      end

      it 'should only create 3 transactions ' do
        expect do
          post path, params: atts.to_json, headers: headers(terminal)
        end.to change(owner.transactions, :count).by(3)
      end

      it 'should add a note  in the alert field' do
        post path, params: atts.to_json, headers: headers(terminal)
        owner.reload
        expect(owner.transactions.first.alert).to include 'Unable to pay'
      end
    end
  end
end
