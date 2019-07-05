# frozen_string_literal: true

module Rezzable
  # Model for inworld terminals
  class Terminal < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'

    has_many :splits, as: :splittable,
                      class_name: 'Analyzable::Split',
                      dependent: :destroy

    accepts_nested_attributes_for :splits, allow_destroy: true

    has_paper_trail
  end
end
