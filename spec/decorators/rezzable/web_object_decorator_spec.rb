# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObjectDecorator do
  describe :slurl do
    let(:web_object) do
      FactoryBot.build :web_object,
                       region: 'Foo Man Choo',
                       position: { x: 10.1, y: 20.32, z: 30.252 }.to_json
    end

    it 'returns the correct url' do
      expect(web_object.decorate.slurl).to eq(
        '<a href="https://maps.secondlife.com/secondlife/' \
        'Foo Man Choo/10/20/30/">Foo Man Choo (10, 20, 30)</a>'
      )
    end
  end
  
  describe :semantic_version do 
    let(:web_object) { FactoryBot.build :web_object,
                                        major_version: 1,
                                        minor_version: 2,
                                        patch_version: 3 }
                                        
    it 'returns a human readable semantic version' do
      expect(web_object.decorate.semantic_version).to eq '1.2.3'
    end
    
    it "returns 'Uknown' if any part of the version is nil" do 
      web_object.major_version = nil 
      expect(web_object.decorate.semantic_version).to eq 'Unknown'
    end
  end
end
