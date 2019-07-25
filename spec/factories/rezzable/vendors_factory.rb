# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_vendor, aliases: [:vendor], class: 'Rezzable::Vendor' do
    association :web_object, factory: :web_object
  end
end
