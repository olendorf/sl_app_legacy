class Rezzable::Inventory < ApplicationRecord
  belongs_to :server, class_name: 'Rezzable::Server'
end
