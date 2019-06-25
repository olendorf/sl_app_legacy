# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

DatabaseCleaner.clean_with :truncation if Rails.env.development?

puts "Creating owner."
owner = FactoryBot.create :owner, avatar_name: 'Owner Resident'

if Rails.env.development?
  puts "Giving owner terminals."
  owner.rezzable_web_objects << FactoryBot.create_list(:terminal, 20)
  Rezzable::Terminal.all.sample(5).each do |t|
    t.rezzable.update_column :pinged_at, rand(2.weeks).seconds.ago
  end 
  
  puts "Creating managers."
  5.times do |i|
    FactoryBot.create :manager, avatar_name: "Manager_#{i} Resident"
  end
  
  puts "Creating users."
  50.times do |i|
    puts "Creating user ##{i}."
    account_level = rand(0..4)
    expiration_date = rand(4.weeks.ago..12.months.from_now) if account_level > 0
    FactoryBot.create :user, avatar_name: "User_#{i} Resident",
                             account_level: account_level,
                             expiration_date: expiration_date
  end
                             
end