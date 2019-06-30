# frozen_string_literal: true

module Analyzable
  # Class for arranging sharing transactions among avatars.
  class Split < ApplicationRecord
    validates_numericality_of :percent,
                              greater_than_or_equal_to: 0,
                              less_than_or_equal_to: 1,
                              message: 'The percent must be between zero and one.'
    validates_presence_of :target_name
    validates_presence_of :target_key

    belongs_to :splittable, polymorphic: true
  end
end
