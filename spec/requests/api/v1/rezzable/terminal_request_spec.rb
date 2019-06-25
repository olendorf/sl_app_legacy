# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'terminal management', type: :request do
  let(:owner) { FactoryBot.create :owner }
  let(:user) { FactoryBot.create :user }
  
  describe 'creating a terminal' do
    let(:path) { api_rezzable_terminals_path }
    context 'as an owner' do 
      let(:terminal) do 
        FactoryBot.build :terminal, user_id: owner.id
      end
      let(:atts) { {url: terminal.url} }
      
      it 'should return created status' do
        post path, params: atts.to_json, 
                   headers: headers(
                     terminal, api_key: Settings.default.web_object.api_key)
        expect(response.status).to eq 201
      end
      
      it 'should create a terminal' do
        expect {
          post path, params: atts.to_json, 
                    headers: headers(
                      terminal, api_key: Settings.default.web_object.api_key)
        }.to change(Rezzable::Terminal, :count).by(1)
      end
      
      it 'returns a nice message do ' do 
        post path, params: atts.to_json, 
                  headers: headers(
                    terminal, api_key: Settings.default.web_object.api_key)
        expect(JSON.parse(response.body)['message']).to eq('The terminal is registered in the database.')
      end 
      
      it 'returns the data' do 
        post path, params: atts.to_json, 
                  headers: headers(terminal, 
                                    api_key: Settings.default.web_object.api_key)
        expect(JSON.parse(response.body)['data']).to eq({
          'api_key' => Rezzable::Terminal.last.api_key
        })
      end
    end 
    
    context 'as a user' do 
      let(:terminal) do 
        FactoryBot.build :terminal, user_id: user.id
      end
      let(:atts) { {url: terminal.url} }
      
      it 'should return unauthorized status' do 
        post path, params: atts.to_json, 
                  headers: headers(terminal, 
                                    api_key: Settings.default.web_object.api_key)
        expect(response.status).to eq 401
      end
    end
    
    context 'user does not exist' do 
      let(:terminal) do 
        FactoryBot.build :terminal
      end
      let(:atts) { {url: terminal.url} }
      
      it 'should return not found status' do 
        post path, params: atts.to_json, 
                  headers: headers(
                    terminal, avatar_key: SecureRandom.uuid,
                    api_key: Settings.default.web_object.api_key)
        expect(response.status).to eq 404
      end
    end
  end
  
  describe 'showing terminal data' do
    let(:path) { api_rezzable_terminal_path(terminal.object_key) }
    
    context 'user exists' do 
      let(:terminal) { FactoryBot.create :terminal, user_id: owner.id }
      before(:each) { get path, headers: headers(terminal) }
      it 'should return OK status' do 
        expect(response.status).to eq 200
      end 
      
      it 'should return the data' do 
        expect(JSON.parse(response.body)['data']).to eq({
          'updated_at' => terminal.updated_at.to_s(:long)
        })
      end
    end 
    
    context 'user does not exists' do 
      let(:terminal) { FactoryBot.create :terminal }
      it 'should return NOT FOUND status' do 
        get path, headers: headers(terminal, avatar_key: SecureRandom.uuid)
        expect(response.status).to eq 404
      end 
    end
  end
  
  describe 'updating a terminal' do
    let(:path) { api_rezzable_terminal_path(terminal.object_key) }
    context 'owner exists' do
      let(:terminal) { FactoryBot.create :terminal, user_id: owner.id }
      let(:old_url) { terminal.url }
      context 'valid data' do 
        let(:atts) { {description: 'some new idea', url: 'http://example.com'} }
        before(:each) { put path, params: atts.to_json, headers: headers(terminal) }
        it 'returns OK status' do 
          expect(response.status).to eq 200
        end
        
        it 'returns a nice message' do 
          expect(JSON.parse(response.body)['message']).to eq 'The terminal has been updated in the database.'
        end 
        
        it 'updates the terminal' do 
          terminal.reload
          expect(terminal.description).to eq atts[:description]
        end 
      end 
      
      context 'invalid data' do 
        let(:atts) { {description: 'some new idea', url: ''} }
        before(:each) { put path, params: atts.to_json, headers: headers(terminal) }
        it 'returns BAD REQUEST status' do 
          expect(response.status).to eq 400
        end
        
        it 'returns a helpful message' do
          expect(JSON.parse(response.body)['message']).to eq "Validation failed: Url can't be blank"
        end
        
        it 'should not change the object' do 
          expect(terminal.url).to eq old_url
        end
      end
    end 
    
    context 'user does not exist' do       
      let(:terminal) { FactoryBot.create :terminal }
      let(:atts) { {description: 'some new idea', url: 'http://example.com'} }
      it 'should return NOT FOUND status' do 
        get path, params: atts.to_json, headers: headers(terminal, avatar_key: SecureRandom.uuid)
        expect(response.status).to eq 404
      end 
    end 
  end
  
  describe 'destroying and object' do 
    let(:terminal) { FactoryBot.create :terminal, user_id: owner.id }
    let(:path) { api_rezzable_terminal_path(terminal.object_key) }
    
    it 'should return OK status' do 
      delete path, headers: headers(terminal) 
      expect(response.status).to eq 200
    end
    
    it 'should return a nice message' do 
      delete path, headers: headers(terminal) 
      expect(JSON.parse(response.body)['message']).to eq "The terminal was removed from the database."
    end
    
    it 'should delete the object' do 
      terminal.touch
      expect{
        delete path, headers: headers(terminal) 
      }.to change(Rezzable::Terminal, :count).by(-1)
    end
  end

end 