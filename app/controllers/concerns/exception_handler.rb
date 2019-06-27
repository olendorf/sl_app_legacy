# frozen_string_literal: true

require 'active_support/concern'


module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ArgumentError do |e|
      flash_response(e.message, :error)
    end

    # rescue_from ActiveRecord::RecordNotFound do |e|
    #   puts "rescuing from not found"
    #   flash_response(e.message, :error)
    # end

    # rescue_from Pundit::NotAuthorizedError do |e|
    #   flash_response(e.message, :warning)
    # end

    # rescue_from ActiveRecord::RecordInvalid do |e|
    #   flash_response(e.message, :error)
    # end

    # rescue_from ActionController::BadRequest do |e|
    #   flash_response(e.message, :error)
    # end
  end
end
