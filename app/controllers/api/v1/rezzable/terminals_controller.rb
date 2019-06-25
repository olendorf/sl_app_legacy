# frozen_string_literal: true

module Api
  module V1
    module Rezzable
      # Controller for terminal requests .
      class TerminalsController < Api::V1::RezzableController
        ## Logic is all handled in Api::V1::RezzableController
        ## Just need to impliment the .response_data methods.

        private

        def response_data
          { updated_at: @requesting_object.updated_at.to_s(:long) }
        end
      end
    end
  end
end
