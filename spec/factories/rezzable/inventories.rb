FactoryBot.define do
  factory :rezzable_inventory, class: 'Rezzable::Inventory' do
    inventory_name { "MyString" }
    inventory_type { 1 }
    owner_perms { 1 }
    next_perms { 1 }
    server_id { 1 }
  end
end
