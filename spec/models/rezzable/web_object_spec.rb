# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject, type: :model do
  it { should respond_to :api_key }
  it { should belong_to(:user) }
  it { should have_many(:transactions).dependent(:nullify) }

  it { should validate_presence_of :object_name }
  it { should validate_presence_of :object_key }
  it { should validate_presence_of :region }
  it { should validate_presence_of :position }
  it { should validate_presence_of :url }

  let(:web_object) { FactoryBot.build :web_object }

  describe 'acts as rezzable' do
    it { expect(web_object).to respond_to(:actable_type) }
    it { expect(web_object).to respond_to(:actable_id) }
  end

  describe 'weight' do
    it 'sets the default weight' do
      web_object.valid?
      expect(web_object.weight).to eq Settings.default.web_object.weight
    end
  end

  describe 'pinged_at' do
    it 'should initialize to current time' do
      expect(web_object.pinged_at).to be_within(10.seconds).of(Time.now)
    end
  end

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end
  end

  describe 'active?' do
    it 'returns true when object has been pinged recently' do
      expect(web_object.active?).to be_truthy
    end

    it 'returns false when the object has not been pinged recently' do
      web_object.pinged_at = 1.hour.ago
      expect(web_object.active?).to be_falsey
    end
  end
end
