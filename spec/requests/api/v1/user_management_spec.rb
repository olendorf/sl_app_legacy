require 'rails_helper'


RSpec.describe 'user management', type: :request do
  
  describe 'creating a user' do 
    let(:temp_user) { FactoryBot.create :user }
    let(:web_object) { FactoryBot.build :web_object, user_id: temp_user.id }
    let(:atts) { FactoryBot.attributes_for :user }
    
    context 'valid params' do 
      it 'should return created status' do
        post api_users_path, params: atts.to_json, 
                             headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
        expect(response.status).to eq 201
      end
      
      it 'should create the user' do
        post api_users_path, params: atts.to_json, 
                            headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
        new_user = User.last 
        expect(new_user.avatar_key).to eq atts[:avatar_key]
        expect(new_user.expiration_date).to be_nil
        expect(new_user.account_level).to eq 0
      end
      
      context 'with a starter package' do 
        it 'sets the expiration_date and account_level properly' do
          atts[:starter] = true
          
          post api_users_path, params: atts.to_json, 
                            headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
          new_user = User.last
          expect(new_user.account_level).to eq(1)
          expect(new_user.expiration_date).to be_within(10.seconds).of(4.weeks.from_now)
        end
      end
    end
    
    context 'user exists' do 
      before(:each) {
        atts[:avatar_key] = temp_user.avatar_key
        atts[:avatar_name] = temp_user.avatar_name
      }
      
      it 'should return conflict status' do 
        post api_users_path, params: atts.to_json, 
                            headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
        expect(response.status).to eq 400
      end
      
      it 'should return a helpful message' do
        post api_users_path, params: atts.to_json, 
                            headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
        expect(JSON.parse(response.body)['message']).to include "Avatar key has already been taken"
      end
      
      it 'should not create a user' do 
        temp_user       # so the change method works properly
        expect{ 
          post api_users_path, params: atts.to_json, 
                              headers: headers(web_object, 
                                                api_key: Settings.default.api_key)
        }.to_not change(User, :count)
      end
    end
    
    context 'invalid params' do 
      before(:each) { atts[:password] = 'bad'}
      it 'returns bad request status' do
        post api_users_path, params: atts.to_json, 
                            headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
        expect(response.status).to eq 400
      end
      
      it 'should return a helpful message' do
        post api_users_path, params: atts.to_json, 
                            headers: headers(web_object, 
                                              api_key: Settings.default.api_key)
        expect(JSON.parse(response.body)['message']).to include "Password confirmation doesn't match Password"
      end
      
      it 'should not create a user' do 
        temp_user       # so the change method works properly
        expect{ 
          post api_users_path, params: atts.to_json, 
                              headers: headers(web_object, 
                                                api_key: Settings.default.api_key)
        }.to_not change(User, :count)
      end
    end
  end
  
  describe 'getting user data' do 
    let(:existing_user) { FactoryBot.create :user }
    let(:path) { api_user_path(existing_user.avatar_key) }
    let(:owner) { FactoryBot.create :owner  }
    let(:owner_object) { FactoryBot.create :web_object, user_id: owner.id }
    
    context 'from an owner object' do
      it 'should return ok status' do 
        get path, headers: headers(owner_object)
        expect(response.status).to eq 200
      end
      
      it 'should return the data' do 
        get path, headers: headers(owner_object)
        expected_data = existing_user.attributes.slice('avatar_key', 'avatar_name', 
                                                       'role', 'object_weight', 
                                                       'account_level', 'expiration_date')
        expect(JSON.parse(response.body)['data']).to eq expected_data
      end
    end 
    
    context 'from a manager object' do
      let(:manager) { FactoryBot.create :manager }
      let(:manager_object) { FactoryBot.create :web_object, user_id: manager.id }
      it 'should return unauthorized status' do 
        get path, headers: headers(manager_object)
        expect(response.status).to eq 401
      end
    end 
    
    context 'from a user object' do
      let(:user) { FactoryBot.create :user }
      let(:user_object) { FactoryBot.create :web_object, user_id: user.id }
      it 'should return unauthorized status' do 
        get path, headers: headers(user_object)
        expect(response.status).to eq 401
      end
    end
    
    context 'from an unknown user' do 
      it 'should return not found status' do 
        get api_user_path(SecureRandom.uuid), headers: headers(owner_object)
        expect(response.status).to eq 404
      end
    end
  end
  
end