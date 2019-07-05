# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::Server, type: :model do
  it { should have_many(:inventories).dependent(:destroy) }
  it { should respond_to :web_object }
  it { should have_many(:clients).dependent(:nullify) }

  let(:server) { FactoryBot.create :server }

  it 'has a counter_cache' do
    expect do
      server.inventories << FactoryBot.build(:inventory)
    end.to change(server, :inventory_count).by(1)
  end
end
