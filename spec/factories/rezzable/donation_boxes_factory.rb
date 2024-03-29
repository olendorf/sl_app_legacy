# frozen_string_literal: true

FactoryBot.define do
  factory :rezzable_donation_box, class: 'Rezzable::DonationBox' do
    reset_period { [0, 604_800, 2_419_200].sample }
    last_donor { rand(0..1) }
    last_donation { rand(0..1) }
    biggest_donor { rand(0..1) }
  end
end
