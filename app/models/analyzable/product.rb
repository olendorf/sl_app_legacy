class Analyzable::Product < ApplicationRecord
  belongs_to :user
  has_many :product_names, class_name: 'Analyzable::ProductName', dependent: :destroy
end
