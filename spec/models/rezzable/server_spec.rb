require 'rails_helper'

RSpec.describe Rezzable::Server, type: :model do
  it { should have_many(:inventories).dependent(:destroy) }
  it { should respond_to :web_object }
end
