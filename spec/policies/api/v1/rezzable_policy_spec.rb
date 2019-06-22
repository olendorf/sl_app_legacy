require 'rails_helper'

RSpec.describe Api::V1::RezzablePolicy, type: :policy do
  let(:active_user) do
    FactoryBot.create_user,  expiration_date: 1.month.from_now,
                             account_level: 1
  end
  
  let(:inactive) do 
    FactoryBot.create_user,  account_level: 0
  end
  
  let(:web_object) { FactoryBot.build :web_object }
  
  class dummy_object < Rezzable::WebObject
    OBJECT_WEIGHT = 50
  end 
  
          

  subject { described_class }

  permissions :show?, :destroy? do
    context 'user is active' do 
      it 'grants permission to the user'
        expect(subject).to permit(active_user, web_object)
      end 
    end
    
    context 'user is inactive' do 
      it 'grants permission to the user '
      context 'user is inactive' do 
        expect(subject).to permit(inactive_user, web_object)
      end
    end 
  end
  
  permissions :update? do 
    context 'user is active' do 
      it 'grants permission to the user'
        expect(subject).to permit(active_user, web_object)
      end 
    end
    
    context 'user is inactive' do 
      it 'denies permission to the user '
      context 'user is inactive' do 
        expect(subject).to_not permit(inactive_user, web_object)
      end
    end 
  end 

  permissions :create? do
    context 'user is inactive' do 
    end 
    
    context 'user is active' do 
      context 'user has enough reserve object weight' do 
      end 
      
      context 'user does not have enough reserve object weight' do 
      end 
    end 
  end

end
