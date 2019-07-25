class Analyzable::Product < ApplicationRecord
  
  # validates_uniqueness_of :product_name
  validates :product_name, uniqueness: { scope: :user_id }
  
  belongs_to :user
  has_many :aliases, class_name: 'Analyzable::ProductAlias', dependent: :destroy
end
