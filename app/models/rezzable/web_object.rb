# frozen_string_literal: true

module Rezzable
  # Base class for all in world object models, use acts_as
  # relationship with child models.
  class WebObject < ApplicationRecord
    after_initialize :set_weight
    after_initialize :set_api_key

    actable inverse_of: 'rezzable'

    validates_presence_of :object_name
    validates_presence_of :object_key
    validates_presence_of :region
    validates_presence_of :position
    validates_presence_of :url

    belongs_to :user, dependent: :destroy

    private

    def set_api_key
      self.api_key ||= SecureRandom.uuid
    end

    def set_weight
      self.weight ||= Settings.default.web_object.weight
    end
  end
end
