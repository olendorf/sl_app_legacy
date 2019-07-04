# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::Split, type: :model do
  it { should validate_presence_of :target_name }
  it { should validate_presence_of :target_key }
  it {
    should validate_numericality_of(:percent)
      .is_greater_than_or_equal_to(0.0)
      .is_less_than_or_equal_to(1.0)
      .with_message('The percent must be between zero and one.')
  }

  it { should belong_to(:splittable) }
end
