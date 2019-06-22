# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

DatabaseCleaner.clean_with :truncation if Rails.env.development?

FactoryBot.create :owner, avatar_name: 'Owner Resident'

if Rails.env.development?
  
  5.times do |i|
    FactoryBot.create :manager, avatar_name: "Manager_#{i} Resident"
  end
  50.times do |i|
    account_level = rand(0..4)
    expiration_date = rand(4.weeks.ago..12.months.from_now) if account_level > 0
    FactoryBot.create :user, avatar_name: "User_#{i} Resident",
                             account_level: account_level,
                             expiration_date: expiration_date
  end
                             
end