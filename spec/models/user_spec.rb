# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # class DummyModel < Rezzable::WebObject
  #   WEIGHT = 60
  # end
  it { should have_many(:web_objects).dependent(:destroy) }
  it { should have_many(:transactions).dependent(:destroy) }
  it { should have_many(:splits).dependent(:destroy) }
  it { should have_many(:products).dependent(:destroy) }
  it { should have_many(:managers).dependent(:destroy) }

  it { should define_enum_for(:role).with_values(%i[user manager owner]) }

  it { should validate_uniqueness_of(:avatar_key).ignoring_case_sensitivity }
  it { should validate_presence_of :avatar_name }
  it {
    should validate_numericality_of(:account_level).is_greater_than_or_equal_to(0)
  }

  let(:user) { FactoryBot.create :user }
  let(:manager) { FactoryBot.build :manager }
  let(:owner) { FactoryBot.create :owner }
  let(:web_object) { FactoryBot.create :web_object, user_id: user.id }

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

  describe 'weight_limit' do
    it 'returns the correct weight limit' do
      user.account_level = 2
      expect(user.weight_limit).to eq 2 * Settings.account.max_weight_per_level
    end
  end

  describe 'active?' do
    it 'returns false when the user has acccount zero' do
      user.account_level = 0
      expect(user.active?).to be_falsey
    end

    it 'returns false when the users expiration_date has exprired' do
      user.account_level = 1
      user.expiration_date = 1.week.ago
      expect(user.active?).to be_falsey
    end

    it 'returns true when account zero is positive and expriation date is good' do
      user.account_level = 2
      user.expiration_date = 1.week.from_now
      expect(user.active?).to be_truthy
    end
  end

  describe 'can_add_object?' do
    context 'when user is active' do
      context 'user has adequate weight' do
        it 'returns true' do
          user.account_level = 1
          user.expiration_date = 1.month.from_now
          expect(user.can_add_object?(FactoryBot.build(:web_object))).to be_truthy
        end
      end

      context 'user has inadequate weight' do
        it 'returns false' do
          user.web_objects << FactoryBot.build(:web_object)
          expect(user.can_add_object?(FactoryBot.build(:web_object))).to be_falsey
        end
      end
    end

    context 'when user is inactive' do
      it 'returns false' do
        user.account_level = 1
        user.expiration_date = 2.weeks.ago
        expect(user.can_add_object?(FactoryBot.build(:web_object))).to be_falsey
      end
    end
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end
  end

  describe 'balance' do
    it 'should return the correct music' do
      transaction = FactoryBot.build(:transaction)
      user.transactions << transaction
      user.reload
      expect(user.balance).to eq transaction.balance
    end
  end

  describe 'servers' do
    it 'returns the number of web objects that are servers' do
      owner.web_objects << FactoryBot.create_list(:web_object, 5)
      owner.web_objects << FactoryBot.create_list(:server, 3)
      owner.reload
      expect(owner.servers.size).to eq 3
    end
  end

  describe 'vendors' do
    it 'returns the number of web objects that are vendors' do
      owner.web_objects << FactoryBot.create_list(:web_object, 5)
      owner.web_objects << FactoryBot.create_list(:vendor, 2)
      owner.reload
      expect(owner.vendors.size).to eq 2
    end
  end
end
