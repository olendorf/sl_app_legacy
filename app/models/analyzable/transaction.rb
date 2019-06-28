module Analyzable
  # In world transactions. 
  class Transaction < ApplicationRecord
    validates_presence_of :amount
    validates_presence_of :category
    
    enum category: [:other, :account, :tip, :sale, :tier]
    
    belongs_to :user
    belongs_to :web_object, class_name: 'Rezzable::WebObject', foreign_key: 'rezzable_id'
  end
  
end
