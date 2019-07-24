FactoryBot.define do
  factory :analyzable_product, class: 'Analyzable::Product' do
    product_name { Faker::Commerce.product_name }
  end
end
