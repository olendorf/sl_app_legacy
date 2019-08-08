# frozen_string_literal: true

module Rezzable
  # Model for inworld server objects.
  class Server < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'

    has_many :inventories, class_name: 'Analyzable::Inventory', dependent: :destroy
    has_many :clients, class_name: 'Rezzable::WebObject', dependent: :nullify

    accepts_nested_attributes_for :inventories, allow_destroy: true

    def self.weight
      Settings.web_object.server.weight
    end
  end
end
