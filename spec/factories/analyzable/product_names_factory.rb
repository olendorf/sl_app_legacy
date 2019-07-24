FactoryBot.define do
  factory :analyzable_product_name, class: 'Analyzable::ProductName' do
    product_name { Faker::Commerce.product_name }
  end
end
