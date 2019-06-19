require 'rails_helper'


RSpec.describe 'user management', type: :request do
  
  describe 'creating a user' do 
    it 'should return created status' do
      temp_user = FactoryBot.create :user
      web_object = FactoryBot.build :web_object, user_id: temp_user.id
      atts = FactoryBot.attributes_for :user
      post api_users_path, params: atts.to_json, 
                           headers: headers(web_object, 
                                            api_key: Settings.default.api_key)
      puts response.body
      expect(response.status).to eq 201
    end
  end
  
end