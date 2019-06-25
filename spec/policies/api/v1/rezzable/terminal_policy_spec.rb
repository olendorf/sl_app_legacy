# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Rezzable::TerminalPolicy, type: :policy do
  let(:owner) { FactoryBot.create :owner }
  let(:manager) do
    FactoryBot.create :manager,
                      expiration_date: 1.month.from_now,
                      account_level: 1
  end
  let(:user) do
    FactoryBot.create :user,
                      expiration_date: 1.month.from_now,
                      account_level: 1
  end

  let(:terminal) { FactoryBot.build :terminal }

  subject { described_class }

  permissions :create?, :show?, :update?, :destroy? do
    it 'grants permission to an owner' do
      expect(subject).to permit(owner, terminal)
    end

    it 'denies permission to a manager' do
      expect(subject).to_not permit(manager, terminal)
    end

    it 'denies permission to a user' do
      expect(subject).to_not permit(user, terminal)
    end
  end
end
