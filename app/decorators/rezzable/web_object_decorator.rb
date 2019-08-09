# frozen_string_literal: true

module Rezzable
  # Base decorator class for all rezzable web objects.
  # Other rezzables should inherit from this.
  class WebObjectDecorator < ApplicationDecorator
    delegate_all

    # rubocop:disable Metrics/AbcSize
    def slurl
      position = JSON.parse(self.position)
      href = 'https://maps.secondlife.com/secondlife/' +
             region + '/' +
             position['x'].round.to_s + '/' +
             position['y'].round.to_s + '/' +
             position['z'].round.to_s + '/'
      text = "#{region} (#{position['x'].round}, " \
             "#{position['y'].round}, #{position['z'].round})"
      h.link_to(text, href)
    end
    # rubocop:enable Metrics/AbcSize
    
    def semantic_version
      return 'Unknown' if( major_version.nil? || 
                           minor_version.nil? || 
                           patch_version.nil? )
      "#{major_version}.#{minor_version}.#{patch_version}"
    end
  end
end
