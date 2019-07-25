# frozen_string_literal: true

module Rezzable
  # Model for simple one prim vendors
  class Vendor < ApplicationRecord
    acts_as :web_object, class_name: 'Rezzable::WebObject'
  end
end
