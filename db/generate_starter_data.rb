CSV.open("db/product_seeds.csv", "w", :write_headers => true,
:headers => ["name", "description", "price", "photo_url", "stock", "available"]) do |csv|
  25.times do
    name = Faker::Name.unique.name 
    description = Faker::Lorem.sentence
    price = Faker::Commerce.price
    photo_url = Faker::LoremPixel.image
    stock = rand(1...50)
    available = Faker::Boolean.boolean
    
    csv << ["name", "description", "price", "photo_url", "stock", "available"]
  end
end


CSV.open("db/user_seeds.csv", "w", :write_headers => true,
:headers => ["username", "email"]) do |csv|
  25.times do
    username = Faker::Name.unique.name 
    email = Faker::Internet.email 
    
    csv << ["username", "email"]
  end
end


CSV.open("db/order_seeds.csv", "w", :write_headers => true,
:headers => ["email", "address", "name", "cc_num", "cvv_code","zip"]) do |csv|
  25.times do
    email = Faker::Internet.email 
    address = Faker::Address.street_address
    name = Faker::Internet.email 
    cc_num = Faker::CreditCard.visa
    cvv_code = rand(100..999)
    zip = Faker::Address.zip
    
    csv << ["email", "address", "name", "cc_num", "cvv_code","zip"]
  end
end


CSV.open("db/review_seeds.csv", "w", :write_headers => true,
:headers => ["rating", "comment", "product_id"]) do |csv|
  25.times do
    rating = rand(1..5)
    comment = Faker::Lorem.sentence
    product_id = rand(1..25)
    
    csv << ["rating", "comment", "product_id"]
  end
end


CSV.open("db/order_item_seeds.csv", "w", :write_headers => true,
:headers => ["quantity", "product_id", "order_id"]) do |csv|
  25.times do
    quantity = nil
    product_id = rand(1..25)
    order_id = rand(1..25)
    
    csv << ["quantity", "product_id", "order_id"]
  end
end
