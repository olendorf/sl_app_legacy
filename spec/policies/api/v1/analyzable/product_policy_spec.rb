# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Analyzable::ProductPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :show? do
    it 'should grant permission to active users' do
      user = FactoryBot.create :active_user
      product = FactoryBot.create :product, user_id: user.id
      expect(subject).to permit user, product
    end

    it 'should grant permission to owners' do
      user = FactoryBot.create :owner
      product = FactoryBot.create :product, user_id: user.id
      expect(subject).to permit user, product
    end

    it 'should not grant permission to inactive users' do
      user = FactoryBot.create :inactive_user
      product = FactoryBot.create :product, user_id: user.id
      expect(subject).to_not permit user, product
    end
  end
end
