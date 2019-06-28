require 'rails_helper'

RSpec.describe Analyzable::Transaction, type: :model do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :category }
  
  it { should define_enum_for(:category).with_values([:other, :account, :tip, :sale, :tier]) }
  
  it { should belong_to :user }
  it { should belong_to(:web_object).with_foreign_key('rezzable_id') }
end
