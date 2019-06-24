# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_terminal, aliases: [:terminal], class: 'Rezzable::Terminal' do
    # object_name { Faker::Commerce.product_name[0, 63] }
    # description { rand < 0.5 ? '' : Faker::Hipster.sentence[0, 126] }
    # object_key { SecureRandom.uuid }
    # region { Faker::Lorem.words(rand(1..3)).map(&:capitalize).join(' ') }
    # position do
    #   { x: (rand * 256), y: (rand * 256), z: (rand * 4096) }.map do |k, v|
    #     [k, v.round(4)]
    #   end .to_h.to_json
    # end
    # api_key { SecureRandom.uuid }
    # url { "https://sim3015.aditi.lindenlab.com:12043/cap/#{object_key}" }

    association :rezzable, factory: :web_object
  end
end
