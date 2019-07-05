FactoryBot.define do
  factory :rezzable_server, aliases: [:server], class: 'Rezzable::Server' do
    association :web_object, factory: :web_object
  end
end
