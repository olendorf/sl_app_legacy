# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Listable::Avatar, type: :model do
  it { should belong_to(:listable) }
  it {
    should validate_uniqueness_of(:avatar_key)
      .scoped_to(:listable_id, :listable_type)
  }
end
