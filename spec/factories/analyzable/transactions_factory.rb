# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_transaction, aliases: [:transaction],
                                   class: 'Analyzable::Transaction' do
    amount { rand(0..2000) }
    # type {  }
    description { Faker::Movies::Lebowski.quote }
  end
end
