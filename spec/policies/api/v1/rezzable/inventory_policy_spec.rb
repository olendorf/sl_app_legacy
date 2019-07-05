require 'rails_helper'

RSpec.describe Api::V1::Rezzable::InventoryPolicy, type: :policy do
  

  subject { described_class }
  
  let(:inventory) { FactoryBot.build :inventory }

  permissions :create?, :update?, :destroy? do
    it 'should grant permission to active users' do 
      user = FactoryBot.create :active_user
      expect(subject).to permit user, inventory
    end
    
    it 'should grant permission to owners' do 
      user = FactoryBot.create :owner
      expect(subject).to permit user, inventory
    end
    
    it 'should not grant permission to inactive users' do 
      user = FactoryBot.create :inactive_user
      expect(subject).to_not permit user, inventory
    end
    
  end
  
end
