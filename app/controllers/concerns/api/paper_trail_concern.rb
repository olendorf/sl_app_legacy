# frozen_string_literal: true

# Api namespace
require 'active_support/concern'

module Api
  # Handles methods associated with paper trail, moslty removes them from
  # api controller so as not to screw up code coverage
  module PaperTrailConcern
    extend ActiveSupport::Concern

    # Override paper trail  to get the correct user for the api call
    def user_for_paper_trail
      @requesting_object.user_id
    end
  end
end
