# frozen_string_literal: true

module Analyzable
  # Decorator for Analyzable::Transaction objects
  class TransactionDecorator < ApplicationDecorator
    delegate_all
    include Rails.application.routes.url_helpers

    # rubocop:disable Metrics/AbcSize
    def source_link
      if web_object
        if web_object.actable.nil?
          slug = 'rezzable_web_object'
          h.link_to web_object.object_name, send("admin_#{slug}_path", web_object)
        else
          slug = web_object.actable.class.name.underscore.gsub('/', '_')
          h.link_to web_object.object_name, send("admin_#{slug}_path", web_object.actable.id)
        end
      else
        'Web Generated'
      end
    end
    # rubocop:enable Metrics/AbcSize

    # Define presentation-specific methods here. Helpers are accessed through
    # `helpers` (aka `h`). You can override attributes, for example:
    #
    #   def created_at
    #     helpers.content_tag :span, class: 'time' do
    #       object.created_at.strftime("%a %m/%d/%y")
    #     end
    #   end
  end
end
