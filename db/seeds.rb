# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

ORDERS_FILE = Rails.root.join('db', 'order_seeds.csv')
puts "Loading raw orders data from #{ORDERS_FILE}"

orders_failures = []
CSV.foreach(ORDERS_FILE, :headers => true) do |row|
  order = Order.new
  order.email = row['email']
  order.address = row['address']
  order.name = row['name']
  order.cc_num = row['cc_num']
  order.cvv_code = row['cvv_code']
  order.zip = row['zip']
  
  successful = order.save
  if !successful
    orders_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "Created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} order records"
puts "#{orders_failures.length} orders failed to save"


USERS_FILE = Rails.root.join('db', 'user_seeds.csv')
puts "Loading raw user data from #{USERS_FILE}"

users_failures = []
CSV.foreach(USERS_FILE, :headers => true) do |row|
  user = User.new
  user.username = row['username']
  user.email = row['email']
  
  successful = user.save
  if !successful
    users_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{users_failures.length} user failed to save"



PRODUCTS_FILE = Rails.root.join('db', 'product_seeds.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

products_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new
  product.name = row['name']
  product.description = row['description']
  product.price = row['price']
  product.photo_url = row['photo_url']
  product.stock = row['stock']
  product.available = row['available']
  product.user_id = rand(1..25)
  
  successful = product.save
  if !successful
    products_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{products_failures.length} products failed to save"


ORDER_ITEM_FILE = Rails.root.join('db', 'order_item_seeds.csv')
puts "Loading raw order_item data from #{ORDER_ITEM_FILE}"

order_item_failures = []
CSV.foreach(ORDER_ITEM_FILE, :headers => true) do |row|
  order_item = OrderItem.new
  order_item.quantity = row['quantity']
  order_item.product_id = row['product_id']
  order_item.order_id = row['order_id']
  successful = order_item.save
  if !successful
    order_item_failures << order_item
    puts "Failed to save order_item: #{order_item.inspect}"
  else
    puts "Created order_item: #{order_item.inspect}"
  end
end

puts "Added #{OrderItem.count} order_item records"
puts "#{order_item_failures.length} order_items failed to save"


REVIEWS_FILE = Rails.root.join('db', 'review_seeds.csv')
puts "Loading raw review data from #{REVIEWS_FILE}"

reviews_failures = []
CSV.foreach(REVIEWS_FILE, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.comment = row['comment']
  review.product_id = row['product_id']
  
  successful = review.save
  if !successful
    reviews_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{reviews_failures.length} review failed to save"
