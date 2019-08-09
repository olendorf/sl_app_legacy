# frozen_string_literal: true

module Listable
  # Facilitates making of various lists such as managers, black listed avatars etc.
  class Avatar < ApplicationRecord
    validates :avatar_key, uniqueness: { scope: %i[listable_id listable_type] }
    belongs_to :listable, polymorphic: true
  end
end
