# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'testt', type: :request do
  it 'returns ok status' do
    get api_test_path
    expect(response.status).to eq 200
  end
end
