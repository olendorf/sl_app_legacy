# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Analyzable::TransactionPolicy, type: :policy do
  let(:user) do
    FactoryBot.create :user, account_level: 1,
                             expiration_date: 1.week.from_now
  end
  let(:owner) { FactoryBot.create :owner }

  subject { described_class }

  permissions :create? do
    it 'should allow an owner' do
      expect(subject).to permit(owner, Analyzable::Transaction)
    end

    it 'should allow an active user' do
      expect(subject).to permit(user, Analyzable::Transaction)
    end

    it 'should not allow an inactive user' do
      user.expiration_date = 1.week.ago
      expect(subject).to_not permit(user, Analyzable::Transaction)
    end
  end
end
