# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject, type: :model do
  it { should respond_to :api_key }
  it { should belong_to(:user).dependent(:destroy) }
  
  it { should validate_presence_of :object_name }
  it { should validate_presence_of :object_key }
  it { should validate_presence_of :region }
  it { should validate_presence_of :position }
  it { should validate_presence_of :url }
  
  let(:web_object) { FactoryBot.build :web_object }
  
  describe "acts as rezzable" do
    it { expect(web_object).to respond_to(:actable_type) }
    it { expect(web_object).to respond_to(:actable_id) }
  end

  describe 'weight' do
    it 'sets the default weight' do
      web_object.valid?
      expect(web_object.weight).to eq Settings.default.web_object.weight
    end
  end
end
