# frozen_string_literal: true

module Rezzable
  # Base class for all in world object models, use acts_as
  # relationship with child models.
  class WebObject < ApplicationRecord
    after_initialize :set_weight
    
    actable inverse_of: 'rezzable'

    belongs_to :user, dependent: :destroy, optional: true

    # WEIGHT = 1000000

    def set_weight
      self.weight ||= Settings.default.web_object.weight
    end
  end
end
