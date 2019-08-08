require 'rails_helper'

RSpec.describe Api::V1::Listable::AvatarPolicy, type: :policy do

  subject { described_class }
  
  let(:avatar) { FactoryBot.build :listable_avatar }
    permissions :create?, :index? do
    it 'should grant permission to active users' do
      user = FactoryBot.create :active_user
      expect(subject).to permit user, Listable::Avatar
    end

    it 'should grant permission to owners' do
      user = FactoryBot.create :owner
      expect(subject).to permit user, Listable::Avatar
    end

    it 'should not grant permission to inactive users' do
      user = FactoryBot.create :inactive_user
      expect(subject).to_not permit user, Listable::Avatar
    end
  end
  
  permissions :destroy?, :show? do
    it 'should grant permission to active users' do
      user = FactoryBot.create :active_user
      expect(subject).to permit user, avatar
    end

    it 'should grant permission to owners' do
      user = FactoryBot.create :owner
      expect(subject).to permit user, avatar
    end

    it 'should not grant permission to inactive users' do
      user = FactoryBot.create :inactive_user
      expect(subject).to_not permit user, avatar
    end
  end
end
