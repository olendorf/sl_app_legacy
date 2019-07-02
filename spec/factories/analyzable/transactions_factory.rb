# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_transaction, aliases: [:transaction],
                                   class: 'Analyzable::Transaction' do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.5 ? 'Resident' : Faker::Name.last_name }
    end
    target_name { "#{first_name} #{last_name}" }
    target_key { SecureRandom.uuid }
    amount { rand(-2000..2000) }
    category { Analyzable::Transaction.categories.keys.sample }
    description { Faker::Movies::Lebowski.quote }
  end
end
