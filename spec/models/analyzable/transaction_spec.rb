# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::Transaction, type: :model do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :category }

  it { should define_enum_for(:category).with_values(%i[other account tip sale tier]) }

  it { should belong_to :user }
  it { should belong_to(:web_object).with_foreign_key('rezzable_id') }

  describe :balance do
    let(:user) { FactoryBot.create :user }
    it 'should be be the same as the amount when its the first transaction' do
      transaction = FactoryBot.build :transaction
      user.transactions << transaction

      expect(user.transactions.last.balance).to eq transaction.amount
    end

    it 'should maintain the correct balance' do
      expected_balance = 0
      5.times do
        amount = rand(-2000..2000)
        expected_balance += amount
        user.transactions << FactoryBot.build(:transaction, amount: amount)
      end
      expect(user.transactions.last.balance).to eq expected_balance
    end
  end
  
  describe 'versioning', versioning: true do 
    it 'is versioned' do 
      is_expected.to be_versioned
    end
  end
end
