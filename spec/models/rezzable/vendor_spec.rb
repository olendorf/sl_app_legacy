# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Vendor, type: :model do
  it { should respond_to :web_object }
  
  
  let(:vendor) do
    vendor = FactoryBot.build(:vendor)
    vendor.save
    vendor
  end
  it 'should have weight of 1' do 
    expect(vendor.weight).to eq 1
  end
end
