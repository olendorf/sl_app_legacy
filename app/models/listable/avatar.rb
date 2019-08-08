class Listable::Avatar < ApplicationRecord
  validates :avatar_key, uniqueness: { scope: [:listable_id, :listable_type] }
  belongs_to :listable, polymorphic: true
end
