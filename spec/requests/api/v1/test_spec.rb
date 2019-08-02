# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'test', type: :request do
  let(:user) { FactoryBot.create :user }
  let(:web_object) { FactoryBot.create :web_object, user_id: user.id }
  it 'returns ok status' do
    get api_test_path, headers: headers(web_object)
    expect(response.status).to eq 200
  end
end
