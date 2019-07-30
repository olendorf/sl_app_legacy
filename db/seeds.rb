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
  
  puts "Giving owner products"
  20.times do 
    FactoryBot.create :product, user_id: owner.id
  end
  
  puts "Giving owner servers"
  4.times do |i|
    server = FactoryBot.build :server, object_name: "server #{i}"
    owner.web_objects << server 
    rand(1..20).times do |i|
      inventory = FactoryBot.create(:inventory, inventory_name: "Inventory #{i}")
      server.inventories << inventory
      if rand < 0.25
        FactoryBot.create :product, product_name: inventory.inventory_name, user_id: owner.id unless Analyzable::Product.find_by_product_name(inventory.inventory_name)
      else
        owner.products.sample.aliases << FactoryBot.create(:alias, alias_name: inventory.inventory_name)
      end
    end
  end
  
  puts "Giving owner vendors"
  10.times do |i|
    vendor = FactoryBot.build :vendor, object_name: "vendor #{i}"
    owner.web_objects << vendor
    server = owner.servers.sample
    vendor.server = server
    vendor.inventory_name = server.inventories.sample.inventory_name
    vendor.save
    # 40.times do |i|
    # end
  end
  
  puts "Giving owner terminals."
  20.times do 
    terminal = FactoryBot.build :terminal
    owner.web_objects << terminal
  end 
  
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
    
    rand(0..20).times do |i|
      FactoryBot.create :product, product_name: "product #{i}", user_id: user.id 
    end
    
    rand(1..5).times do |i|
      user.web_objects << FactoryBot.build(:server, object_name: "server #{i}")
      rand(1..50).times do |j|
        inventory = FactoryBot.create(:inventory, inventory_name: "inventory #{j}")
        user.web_objects.last.inventories << inventory
        if rand < 0.25
          FactoryBot.create :product, product_name: inventory.inventory_name, user_id: user.id unless Analyzable::Product.find_by_product_name(inventory.inventory_name)
        else
          owner.products.sample.aliases << FactoryBot.create(:alias, alias_name: inventory.inventory_name)
        end
      end
    end
    
    
    rand(0..25).times do |i|
      vendor = FactoryBot.build :vendor, object_name: "vendor #{i}"
      user.web_objects << vendor
      server = user.servers.sample
      vendor.server = server
      vendor.inventory_name = server.inventories.sample.inventory_name
      vendor.save
    end
    10.times do 
      transaction = FactoryBot.build(:transaction)
      transaction.category = (Analyzable::Transaction.categories.keys - ['account']).sample
      user.transactions << transaction
      
      if rand < 0.3 && transaction.amount.positive?
        rand(4).times do 
          splt = FactoryBot.build :transaction, amount: transaction.amount * -0.1
          transaction.sub_transactions << splt
          user.transactions << splt
        end
      end
    end
  end
                             
end