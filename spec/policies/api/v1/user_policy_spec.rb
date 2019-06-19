require 'rails_helper'

RSpec.describe Api::V1::UserPolicy, type: :policy do
  let(:user) { FactoryBot.create :user }
  let(:manager) { FactoryBot.create :manager }
  let(:owner) { FactoryBot.create :owner }

  subject { described_class }

  permissions :show?, :destroy?, :update? do
    context 'when object belongs to an owner' do
      it 'grants access' do
        expect(subject).to permit(owner, user)
      end
    end
    
    context 'when object belongs to an manager' do
      it 'denies access' do
        expect(subject).not_to permit(manager, user)
      end
    end 
    
    context 'when object belongs to an owner' do 
      it 'denies access' do
        expect(subject).not_to permit(manager, user)
      end
    end
  end

  permissions :create? do    context 'when object belongs to an owner' do
    it 'grants access' do
        expect(subject).to permit(owner, user)
      end
    end
    
    context 'when object belongs to an manager' do
      it 'grants access' do
        expect(subject).to permit(manager, user)
      end
    end 
    
    context 'when object belongs to an owner' do 
      it 'grants access' do
        expect(subject).to permit(manager, user)
      end
    end
  end
end
