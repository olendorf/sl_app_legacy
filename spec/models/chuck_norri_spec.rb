# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChuckNorri, type: :model do
  it 'should work' do
    chuck = FactoryBot.create :chuck_norri
    expect(chuck.knockouts).to be >= 0
  end
end
