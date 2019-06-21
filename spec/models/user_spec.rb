# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :rezzable_web_objects }

  it { should define_enum_for(:role).with_values(%i[user manager owner]) }

  it { should validate_uniqueness_of(:avatar_key).ignoring_case_sensitivity }
  it { should validate_presence_of :avatar_name }
  it {
    should validate_numericality_of(:account_level).is_greater_than_or_equal_to(0)
  }

  let(:user) { FactoryBot.build :user }
  let(:manager) { FactoryBot.build :manager }
  let(:owner) { FactoryBot.build :owner }

  describe 'starter_account' do
    context 'when account_level is zero' do
      let(:user) { FactoryBot.create :user, account_level: 0, starter: 1 }
      it 'should set the account level and expiration date' do
        expect(user.account_level).to eq 1
        expect(user.expiration_date).to be_within(10.seconds).of(1.month.from_now)
      end
    end
  end

  describe 'increasing account_level' do
    context 'when it is greater than zero' do
      let(:user) do
        FactoryBot.create :user, account_level: 2,
                                 expiration_date: 3.months.from_now
      end
      it 'adjusts the expiration_date' do
        user.account_level = 3
        user.save
        expect(
          user.expiration_date
        ).to be_within(
          10.seconds
        ).of(Time.now + (3.months.from_now - Time.now) * 2.0 / 3)
      end
    end

    context 'when it is zero' do
      let(:user) { FactoryBot.create :user, account_level: 0 }
      it 'raises and exception' do
        user.account_level = 1
        expect { user.save }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'decreasing account level' do
    context 'when is is greater than two' do
      let(:user) do
        FactoryBot.create :user, account_level: 3,
                                 expiration_date: 3.month.from_now
      end
      it 'adjusts the expiration_date' do
        user.account_level = 2
        user.save
        expect(
          user.expiration_date
        ).to be_within(10.seconds).of(Time.now + (3.months.from_now - Time.now) * 3.0 / 2)
      end
    end

    context 'decreasing account level to zero' do
      let(:user) { FactoryBot.create :user, account_level: 1 }
      it 'sets expiration_date to nil' do
        user.account_level = 0
        user.save
        expect(user.expiration_date).to be_nil
      end
    end

    context 'when it is zero' do
    end
  end

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

  describe 'handling payments' do
    context 'when use has account_level zero' do
      let(:user) { FactoryBot.create :user, account_level: 0 }
      context 'and makes a one month payment' do
        before(:each) do
          user.payment = Settings.account.price_per_level[1]
          user.period = 1
          user.save
          user.reload
        end
        it 'adds one month to the expiration_date' do
          expect(user.expiration_date).to be_within(10.seconds).of(1.month.from_now)
        end
        it 'sets account_level to one' do
          expect(user.account_level).to eq 1
        end
      end

      context 'and makes a six month payment' do
        before(:each) do
          user.payment = Settings.account.price_per_level[6]
          user.period = 6
          user.save
          user.reload
        end
        it 'adds one month to the expiration_date' do
          expect(user.expiration_date).to be_within(10.seconds).of(6.month.from_now)
        end
        it 'sets account_level to one' do
          expect(user.account_level).to eq 1
        end
      end
    end
    context 'when user has account_level one' do
      let(:user) do
        FactoryBot.create :user, account_level: 1,
                                 expiration_date: 1.month.from_now
      end
      before(:each) do
        user.payment = Settings.account.price_per_level[3]
        user.period = 3
        user.save
        user.reload
      end
      it 'adds the time to the expiration_date' do
        expect(user.expiration_date).to be_within(10.seconds).of(4.months.from_now)
      end

      it 'it does not change account_level' do
        expect(user.account_level).to eq 1
      end
    end

    context 'when user has account_level three' do
      let(:user) do
        FactoryBot.create :user, account_level: 3,
                                 expiration_date: 1.month.from_now
      end
      before(:each) do
        user.payment = Settings.account.price_per_level[3] * 3
        user.period = 3
        user.save
        user.reload
      end
      it 'adds the time to the expiration_date' do
        expect(user.expiration_date).to be_within(10.seconds).of(4.months.from_now)
      end

      it 'it does not change account_level' do
        expect(user.account_level).to eq 3
      end
    end

    context 'user is in grace period' do
      let(:user) do
        FactoryBot.create :user, account_level: 2,
                                 expiration_date: 1.week.ago
      end
      before(:each) do
        user.payment = Settings.account.price_per_level[3] * 2
        user.period = 3
        user.save
        user.reload
      end
      it 'adds the correct time to the expiration_date' do
        expect(user.expiration_date).to be_within(10.seconds).of(1.week.ago + 3.months)
      end
      it 'should not change account_level' do
        expect(user.account_level).to eq 2
      end
    end

    context 'user submits invalid payment' do
      context 'account level is greater than zero' do
        let(:user) do
          FactoryBot.create :user, account_level: 1,
                                   expiration_date: 1.month.from_now
        end
        before(:each) do
          user.payment = 42
          user.period = 3
        end

        it 'returns an ArgumentError' do
          expect { user.save }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
