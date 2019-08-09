# frozen_string_literal: true

FactoryBot.define do
  factory :listable_avatar, class: 'Listable::Avatar' do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.5 ? 'Resident' : Faker::Name.last_name }
    end
    avatar_name { "#{first_name} #{last_name}" }
    avatar_key { SecureRandom.uuid }

    factory :listed_manager do
      list_name { 'manager' }
    end
  end
end
