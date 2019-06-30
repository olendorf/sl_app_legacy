# frozen_string_literal: true

FactoryBot.define do
  factory :analyzable_split, aliases: [:split], class: 'Analyzable::Split' do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.5 ? 'Resident' : Faker::Name.last_name }
    end
    target_name { "#{first_name} #{last_name}" }
    target_key { SecureRandom.uuid }
    percent { rand }
  end
end
