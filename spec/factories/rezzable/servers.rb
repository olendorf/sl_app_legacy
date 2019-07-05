FactoryBot.define do
  factory :rezzable_server, class: 'Rezzable::Server' do
    inventory_count { 1 }
  end
end
