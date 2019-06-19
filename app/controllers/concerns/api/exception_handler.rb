# frozen_string_literal: true

require 'active_support/concern'

module Api
  # Handles Exceptions thrown in the API
  module ExceptionHandler
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        json_response({ message: e.message }, :not_found)
      end
  
      rescue_from ActionController::BadRequest do |e|
        json_response({ message: e.message }, :bad_request)
      end
    end
  end
end
