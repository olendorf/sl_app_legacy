# frozen_string_literal: true

module Rezzable
  # Base class for all in world object models, use acts_as
  # relationship with child models.
  class WebObject < ApplicationRecord
    after_initialize :set_weight
    after_initialize :set_api_key
    after_initialize :set_pinged_at

    actable inverse_of: 'rezzable'

    validates_presence_of :object_name
    validates_presence_of :object_key
    validates_presence_of :region
    validates_presence_of :position
    validates_presence_of :url

    belongs_to :user

    has_many :transactions, class_name: 'Analyzable::Transaction',
                            dependent: :nullify,
                            foreign_key: 'rezzable_id'

    def active?
      pinged_at > Settings.default.web_object.inactive_time.minutes.ago
    end

    private

    def set_api_key
      self.api_key ||= SecureRandom.uuid
    end

    def set_weight
      self.weight ||= Settings.default.web_object.weight
    end

    def set_pinged_at
      self.pinged_at ||= Time.now
    end
  end
end
