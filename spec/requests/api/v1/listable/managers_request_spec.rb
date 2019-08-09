# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'manager management' do
  let(:active_user) { FactoryBot.create :active_user }
  let(:web_object) { FactoryBot.create :web_object, user_id: active_user.id }
  let(:inactive_user) { FactoryBot.create :inactive_user }
  let(:inactive_web_object) { FactoryBot.create :web_object, user_id: inactive_user.id }

  context 'managers list' do 
    describe 'create' do
      let(:path) { api_listable_managers_path }
      context 'avatar is not listed for user' do
        let(:atts) { FactoryBot.attributes_for :listed_manager }
  
        it 'returns created status' do
          post path, params: atts.to_json, headers: headers(web_object)
          expect(response.status).to eq 201
        end
  
        it 'returns a nice message' do
          post path, params: atts.to_json, headers: headers(web_object)
          expect(JSON.parse(response.body)['message']).to eq 'Created'
        end
  
        it 'should create a manager' do
          expect do
            post path, params: atts.to_json, headers: headers(web_object)
          end.to change(Listable::Avatar, :count).by(1)
        end
  
        it 'should add the manager to the user' do
          expect do
            post path, params: atts.to_json, headers: headers(web_object)
          end.to change(active_user.managers, :count).by(1)
        end
      end
  
      context 'avatar is already listed' do
        let(:existing_avatar) do
          FactoryBot.create :listed_manager,
                            listable_id: active_user.id,
                            listable_type: 'User'
        end
        let(:atts) do
          FactoryBot.attributes_for :listed_manager,
                                    avatar_name: existing_avatar.avatar_name,
                                    avatar_key: existing_avatar.avatar_key,
                                    listable_id: active_user.id,
                                    listable_type: 'User'
        end
  
        before(:each) { existing_avatar }
  
        it 'returns OK status' do
          post path, params: atts.to_json, headers: headers(web_object)
          expect(response.status).to eq 400
        end
  
        it 'returns a nice message' do
          post path, params: atts.to_json, headers: headers(web_object)
          expect(
            JSON.parse(response.body)['message']
          ).to eq 'Validation failed: Avatar key has already been taken'
        end
  
        it 'should not create a manager' do
          expect do
            post path, params: atts.to_json, headers: headers(web_object)
          end.to change(Listable::Avatar, :count).by(0)
        end
  
        it 'should not add the manager to the user' do
          expect do
            post path, params: atts.to_json, headers: headers(web_object)
          end.to change(active_user.managers, :count).by(0)
        end
      end
  
      context 'user is inactive' do
        let(:atts) { FactoryBot.attributes_for :listed_manager }
  
        it 'returns created status' do
          post path, params: atts.to_json, headers: headers(inactive_web_object)
          expect(response.status).to eq 401
        end
      end
    end
  
    describe 'index' do
      let(:path) { "#{api_listable_managers_path}?page=all&list=managers" }
      before(:each) do
        21.times do |i|
          active_user.managers << FactoryBot.build(:listed_manager,
                                                   avatar_name: "Resident#{i} Resident")
        end
      end
  
      it 'should return OK status' do
        get path, headers: headers(web_object)
        expect(response.status).to eq 200
      end
  
      it 'returns the all the names' do
        get path, headers: headers(web_object)
        expect(JSON.parse(response.body)['data']['avatars'].size).to eq 21
        expect(
          JSON.parse(response.body)['data']['avatars']
        ).to include(*active_user.managers.map { |m| m.avatar_name })
      end

    end
  
    describe 'destroy' do
      before(:each) do
        21.times do |i|
          active_user.managers << FactoryBot.build(:listed_manager,
                                                   avatar_name: "Resident#{i} Resident")
        end
      end
  
      it 'should return ok status' do
        target = active_user.managers.sample
        path = api_listable_manager_path(CGI.escape(target.avatar_name))
        delete path, headers: headers(web_object)
        expect(response.status).to eq 200
      end
  
      it 'should remove the avatar from the user' do
        target = active_user.managers.sample
        path = api_listable_manager_path(CGI.escape(target.avatar_name))
        delete path, headers: headers(web_object)
        expect(active_user.managers.find_by_avatar_name(target.avatar_name)).to be_nil
      end
  
      it 'should delete the avatar' do
        target = active_user.managers.sample
        path = api_listable_manager_path(CGI.escape(target.avatar_name))
        expect do
          delete path, headers: headers(web_object)
        end.to change(active_user.managers, :count).by(-1)
      end
  
      it 'should return not found status if it does not exist' do
        path = api_listable_manager_path('foo')
        delete path, headers: headers(web_object)
        expect(response.status).to eq 404
      end
    end
  end
end
