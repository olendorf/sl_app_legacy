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
  
  puts "Giving owner servers" do
    4.times do 
      server = FactoryBot.build :server, object_name: "server #{i}"
      owner.web_objects << server 
      rand(0..20).times do |i|
        server.inventories << FactoryBot.create(:inventory, inventory_name: "Inventory #{i}")
      end
    end
  end
  
  puts "Giving owner terminals."
  owner.web_objects << FactoryBot.create_list(:terminal, 20)
  Rezzable::Terminal.all.sample(5).each do |t|
    t.web_object.update_column :pinged_at, rand(2.weeks).seconds.ago
    
    rand(0..20).times do |i|
      transaction = FactoryBot.build :transaction
      if rand < 0.25
        transaction.category = 'account'
        t.transactions << transaction
      else
        transaction.category = (Analyzable::Transaction.categories.keys - ['account']).sample
      end
      owner.transactions << transaction
      if rand < 0.3 && transaction.amount.positive?
        rand(4).times do 
          splt = FactoryBot.build :transaction, amount: transaction.amount * -0.1
          transaction.sub_transactions << splt
          owner.transactions << splt
        end
      end
    end
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
    user = FactoryBot.create :user, avatar_name: "User_#{i} Resident",
                             account_level: account_level,
                             expiration_date: expiration_date
    rand(0..5).times do |i|
      user.web_objects << FactoryBot.create(:server, object_name: "server {i}")
      rand(0..50).times do |j|
        user.web_objects.last.inventories << FactoryBot.create(:inventory, inventory_name: "inventory #{j}")
      end
    end
    10.times do 
      transaction = FactoryBot.build(:transaction)
      transaction.category = (Analyzable::Transaction.categories.keys - ['account']).sample
      user.transactions << transaction
      
      if rand < 0.3 && transaction.amount.positive?
        rand(4).times do 
          splt = FactoryBot.build :transaction, amount: transaction.amount * -0.1
          transaction.sub_transactions << splt
          owner.transactions << splt
        end
      end
    end
  end
                             
end