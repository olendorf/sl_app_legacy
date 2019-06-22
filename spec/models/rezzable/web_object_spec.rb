# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject, type: :model do
  it { should respond_to :api_key }
  it { should belong_to(:user).dependent(:destroy) }
  
  it 'should have the correct OBJECT_WEIGHT' do 
    expect(Rezzable::WebObject::OBJECT_WEIGHT).to eq 1000000
  end
end
