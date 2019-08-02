# frozen_string_literal: true

module Analyzable
  # Decorator for Analyzable::Transaction objects
  class TransactionDecorator < ApplicationDecorator
    delegate_all
    include Rails.application.routes.url_helpers

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def source_link
      if web_object
        if web_object.actable.nil?
          slug = 'rezzable_web_object'
          h.link_to web_object.object_name,
                    send("admin_#{slug}_path",
                         web_object)
        else
          slug = web_object.actable.class.name.underscore.gsub('/', '_')
          h.link_to web_object.object_name,
                    send("admin_#{slug}_path",
                         web_object.actable.id)
        end
      else
        'Web Generated'
      end
    end

    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
