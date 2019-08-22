# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::DonationBox, type: :model do
  it { should respond_to :web_object }

  it { should have_many(:splits).dependent(:destroy) }

  it {
    should define_enum_for(:reset_period)
      .with_values(manual: 0, weekly: 604_800, monthly: 2_419_200)
  }
end
