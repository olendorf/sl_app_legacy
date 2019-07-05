FactoryBot.define do
  factory :rezzable_inventory, aliases: [:inventory], class: 'Rezzable::Inventory' do
    inventory_name { Faker::Commerce.product_name }
    inventory_type { 1 }
    owner_perms { 1 }
    next_perms { 1 }
  end
end
