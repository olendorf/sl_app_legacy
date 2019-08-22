# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_web_object,
          aliases: [:web_object], class: 'Rezzable::WebObject' do
    object_name { Faker::Commerce.product_name[0, 63] }
    description { rand < 0.5 ? '' : Faker::Hipster.sentence[0, 126] }
    object_key { SecureRandom.uuid }
    region { Faker::Lorem.words(number: rand(1..3)).map(&:capitalize).join(' ') }
    position do
      { x: (rand * 256), y: (rand * 256), z: (rand * 4096) }.map do |k, v|
        [k, v.round(4)]
      end .to_h.to_json
    end
    api_key { SecureRandom.uuid }
    url { "https://sim3015.aditi.lindenlab.com:12043/cap/#{object_key}" }
  end
end
