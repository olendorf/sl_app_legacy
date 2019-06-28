module Analyzable
  # In world transactions. 
  class Transaction < ApplicationRecord
    
    before_save :update_balance, if: :user_id
    
    validates_presence_of :amount
    validates_presence_of :category
    
    enum category: [:other, :account, :tip, :sale, :tier]
    
    belongs_to :user
    belongs_to :web_object, class_name: 'Rezzable::WebObject', foreign_key: 'rezzable_id'
    
    private 
    
    def update_balance
      previous_balance = self.user.transactions.last.nil? ? 0 : self.user.transactions.last.balance
      self.balance ||= previous_balance + self.amount
    end
  end
  
end
