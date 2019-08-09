# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'terminal management', type: :request do
  it_should_behave_like 'a owner object API', :terminal
end
