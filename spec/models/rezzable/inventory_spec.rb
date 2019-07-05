require 'rails_helper'

RSpec.describe Rezzable::Inventory, type: :model do
  it { should belong_to(:server) }
end
