class Rezzable::Inventory < ApplicationRecord
  belongs_to :server, class_name: 'Rezzable::Server', counter_cache: :inventory_count
end
