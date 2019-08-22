# frozen_string_literal: true

module Rezzable
  # Rezzable items to allow users to collect donations
  class DonationBox < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'

    has_many :splits, as: :splittable,
                      class_name: 'Analyzable::Split',
                      dependent: :destroy

    enum reset_period: {
      manual: 0,
      weekly: 604_800,
      monthly: 2_419_200
    }
  end
end
