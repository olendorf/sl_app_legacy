# frozen_string_literal: true

FactoryBot.define do
  factory :chuck_norri do
    fact { Faker::ChuckNorris.fact }
    knockouts { rand(0..100) }
  end
end
