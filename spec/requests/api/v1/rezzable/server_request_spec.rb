# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'server management', type: :request do
  it_should_behave_like 'a user object API', :server
end
