# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_product_alias,
          aliases: %i[product_alias alias],
          class: 'Analyzable::ProductAlias' do
    alias_name { Faker::Commerce.product_name }
  end
end
