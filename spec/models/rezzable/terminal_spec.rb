# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Terminal, type: :model do
  it { should have_many(:splits).dependent(:destroy) }
  it { should respond_to :web_object }

  describe 'versioning', versioning: true do
    it 'is versioned' do
      is_expected.to be_versioned
    end
  end
end
