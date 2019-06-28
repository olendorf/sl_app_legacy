# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Terminal, type: :model do
  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end
  end
end
