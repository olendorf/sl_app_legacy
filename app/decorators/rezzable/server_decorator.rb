# frozen_string_literal: true

module Rezzable
  # Decorator class for Rezzable::Server
  class ServerDecorator < Rezzable::WebObjectDecorator
    delegate_all
  end
end
