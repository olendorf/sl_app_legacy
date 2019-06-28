FactoryBot.define do
  factory :analyzable_transaction, class: 'Analyzable::Transaction' do
    amount { rand(0..2000) }
    # type {  }
    description { Faker::Movies::Lebowski.quote }
  end
end
