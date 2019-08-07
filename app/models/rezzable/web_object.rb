# frozen_string_literal: true

module Rezzable
  # Base class for all in world object models, use acts_as
  # relationship with child models.
  class WebObject < ApplicationRecord
    after_initialize :set_api_key
    after_initialize :set_pinged_at
    after_validation :set_weight

    actable inverse_of: 'web_object'

    validates_presence_of :object_name
    validates_presence_of :object_key
    validates_presence_of :region
    validates_presence_of :position
    validates_presence_of :url

    belongs_to :user
    belongs_to :server, class_name: 'Rezzable::Server'

    has_many :transactions, class_name: 'Analyzable::Transaction',
                            dependent: :nullify,
                            foreign_key: 'rezzable_id'

    has_paper_trail ignore: %i[pinged_at weight]

    def active?
      pinged_at > Settings.default.web_object.inactive_time.minutes.ago
    end
    
    def self.weight
      Settings.web_object.weight 
    end

    private

    def set_api_key
      self.api_key ||= SecureRandom.uuid
    end

    # rubocop:disable Metrics/AbcSize
    def set_weight
      if actable_type.nil?
        self.weight ||= Settings.web_object.weight if actable_type.nil?
      else
        self.weight ||= Settings.web_object.send(actable_type.split('::')
                        .last.downcase).weight
      end
    end
    # rubocop:enable Metrics/AbcSize

    def set_pinged_at
      self.pinged_at ||= Time.now
    end
  end
end
