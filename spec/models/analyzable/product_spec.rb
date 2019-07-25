require 'rails_helper'

RSpec.describe Analyzable::Product, type: :model do
  it { should belong_to :user }
  it { should have_many :aliases }
  
  
  it { should validate_uniqueness_of(:product_name).scoped_to(:user_id) }
  
  let(:product) { FactoryBot.create :product }
  
  
end
