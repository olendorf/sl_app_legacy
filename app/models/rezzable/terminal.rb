# frozen_string_literal: true

module Rezzable
  # Model for inworld terminals
  class Terminal < ApplicationRecord
    acts_as :rezzable, class_name: 'Rezzable::WebObject'
    
    has_paper_trail
  end
end

