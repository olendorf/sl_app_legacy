# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_vendor, aliases: [:vendor], class: 'Rezzable::Vendor' do
    association :web_object, factory: :web_object
    image_key {
      [
        '00000000-0000-0000-0000-000000000000',
        'eb6e6d4b-a25a-f080-660e-c61cbd6ed38c',
        '07f71d93-ceee-14bd-597b-078f5125d014',
        '40b0d6d9-ce63-2a6f-e93e-0f269b9d21b3',
        '00000000-0000-0000-0000-000000000000',
        '00000000-0000-0000-0000-000000000000',
        '00000000-0000-0000-0000-000000000000',
        ].sample
    }
  end
end
