FactoryBot.define do
  factory :analyzable_product, aliases: [:product], class: 'Analyzable::Product' do
    product_name { Faker::Commerce.product_name }
    price { rand(0..2000) }
  end
end
