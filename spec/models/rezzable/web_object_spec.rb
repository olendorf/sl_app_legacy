# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject, type: :model do
  it { should respond_to :api_key }
  it { should belong_to(:user).dependent(:destroy) }
end
