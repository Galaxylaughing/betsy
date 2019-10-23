# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

ORDER_ITEM_FILE = Rails.root.join('db', 'order_item_seeds.csv')
puts "Loading raw media data from #{ORDER_ITEM_FILE}"

order_item_failures = []
CSV.foreach(ORDER_ITEM_FILE, :headers => true) do |row|
  order_item = OrderItem.new
  work.category = row['category']
  work.title = row['title']
  work.creator = row['creator']
  work.publication_year = row['publication_year']
  work.description = row['description']
  successful = work.save
  if !successful
    works_failures << work
    puts "Failed to save work: #{work.inspect}"
  else
    puts "Created work: #{work.inspect}"
  end
end

puts "Added #{Work.count} work records"
puts "#{works_failures.length} works failed to save"


USERS_FILE = Rails.root.join('db', 'users_seeds.csv')
puts "Loading raw user data from #{USERS_FILE}"

users_failures = []
CSV.foreach(USERS_FILE, :headers => true) do |row|
  user = User.new
  user.username = row['username']
  
  successful = user.save
  if !successful
    users_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{users_failures.length} users failed to save"


VOTES_FILE = Rails.root.join('db', 'votes_seeds.csv')
puts "Loading raw vote data from #{VOTES_FILE}"

votes_failures = []
CSV.foreach(VOTES_FILE, :headers => true) do |row|
  vote = Vote.new
  vote.user_id = row['user_id']
  vote.work_id = row['work_id']
  
  successful = vote.save
  if !successful
    votes_failures << vote
    puts "Failed to save vote: #{vote.inspect}"
  else
    puts "Created vote: #{vote.inspect}"
  end
end

puts "Added #{Vote.count} vote records"
puts "#{votes_failures.length} votes failed to save"

