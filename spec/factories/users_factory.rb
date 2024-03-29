# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:inactive_user] do
    transient do
      first_name { Faker::Name.first_name }
      last_name { rand < 0.5 ? 'Resident' : Faker::Name.last_name }
    end
    avatar_name { "#{first_name} #{last_name}" }
    avatar_key { SecureRandom.uuid }
    password { 'password' }
    password_confirmation { password }

    factory :active_user do
      account_level { 1 }
      expiration_date { 1.month.from_now }
    end

    factory :manager do
      role { :manager }
    end

    factory :owner do
      role { :owner }
    end
  end
end
