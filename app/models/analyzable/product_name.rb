class Analyzable::ProductName < ApplicationRecord
  belongs_to :product, class_name: 'Analyzable::Product'
end
