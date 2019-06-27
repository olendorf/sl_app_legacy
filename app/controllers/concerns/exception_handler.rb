# frozen_string_literal: true

require 'active_support/concern'

# Handles exceptions for the Web Interface
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ArgumentError do |e|
      flash_response(e.message, :error)
    end
  end
end
