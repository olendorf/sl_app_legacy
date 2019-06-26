require 'rails_helper'

RSpec.describe Rezzable::WebObjectDecorator do
  describe :slurl do
    let(:web_object) { 
      FactoryBot.build :web_object, 
        region: 'Foo Man Choo', 
        position: {x: 10.1, y: 20.32, z: 30.252}.to_json 
    }
    
    it 'returns the correct url' do 
      href = "https://maps.secondlife.com/secondlife/Foo Man Choo/10/20/30/"
      text = "Foo Man Choo (10, 20, 30)"
      expect(web_object.decorate.slurl).to eq(
        '<a href="https://maps.secondlife.com/secondlife/' + 
        'Foo Man Choo/10/20/30/">Foo Man Choo (10, 20, 30)</a>')
    end
  end
  
end
