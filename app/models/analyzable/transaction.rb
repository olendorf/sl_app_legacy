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

    has_paper_trail

    private

    def update_balance
      previous_balance = user.transactions.last.nil? ? 0 : user.transactions.last.balance
      self.balance ||= previous_balance + amount
    end
  end
end
