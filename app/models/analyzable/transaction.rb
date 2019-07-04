# frozen_string_literal: true

module Analyzable
  # In world transactions.
  class Transaction < ApplicationRecord
    before_save :update_balance, if: :user_id

    validates_presence_of :amount
    validates_presence_of :category

    enum category: %i[other account tip sale tier share]

    belongs_to :user
    belongs_to :web_object, class_name: 'Rezzable::WebObject', foreign_key: 'rezzable_id'

    belongs_to :parent_transaction, class_name: 'Analyzable::Transaction',
                                    foreign_key: 'parent_transaction_id'
    has_many :sub_transactions, class_name: 'Analyzable::Transaction',
                                foreign_key: 'parent_transaction_id'

    def category
      read_attribute(:category) == 'share' ? 'split' : read_attribute(:category)
    end

    has_paper_trail

    private

    def update_balance
      puts "current user: #{user.transactions.last.inspect}"
      puts "amount: #{self.amount}"
      previous_balance = user.transactions.last.nil? ? 0 : user.transactions.last.balance
      puts "previous balance: #{previous_balance}"
      self.balance ||= previous_balance + amount
    end
  end
end
