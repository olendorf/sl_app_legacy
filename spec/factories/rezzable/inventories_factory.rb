# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_inventory, aliases: [:inventory], class: 'Rezzable::Inventory' do
    inventory_name { Faker::Commerce.product_name }
    inventory_type { Rezzable::Inventory.inventory_types.keys.sample }
    owner_perms {  Rezzable::Inventory::PERMS.values.sample(rand(0..4)).sum }
    next_perms { Rezzable::Inventory::PERMS.values.sample(rand(0..4)).sum }
  end
end
