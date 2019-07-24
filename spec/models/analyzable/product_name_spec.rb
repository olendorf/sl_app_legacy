require 'rails_helper'

RSpec.describe Analyzable::ProductName, type: :model do
  it { should belong_to :product }
end
