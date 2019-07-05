class Rezzable::Server < ApplicationRecord
  acts_as :web_object, class_name: 'Rezzable::WebObject'
  
  has_many :inventories, class_name: 'Rezzable::Inventory', dependent: :destroy
  has_many :clients, class_name: 'Rezzable::WebObject', dependent: :nullify
end
