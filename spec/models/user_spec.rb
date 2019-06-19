# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#Roles' do
    it 'should enum roles' do
      expect(User.roles).to eq('user' => 0, 'manager' => 1, 'owner' => 2)
    end
  end

  let(:user) { FactoryBot.build :user }
  let(:manager) { FactoryBot.build :manager }
  let(:owner) { FactoryBot.build :owner }

  describe 'can be' do
    User.roles.each do |role, _value|
      it { should respond_to "can_be_#{role}?".to_sym }
    end
    it 'should properly test can_be_<role>?' do
      expect(manager.can_be_owner?).to be_falsey
      expect(manager.can_be_user?).to be_truthy
      expect(owner.can_be_user?).to be_truthy
      expect(user.can_be_manager?).to be_falsey
      expect(user.can_be_user?).to be_truthy
    end
  end
end
