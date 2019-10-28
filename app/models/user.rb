class User < ApplicationRecord
  has_many :products
  
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  def order_count
    orders = self.find_orders
    return orders.count
  end
  
  def top_product
    max = 0
    max_product = nil
    self.products.each do |product|
      
      # should be extracted to a product instance method
      #   total_sold = product.total_sold
      total_sold = 0
      product.order_items.each do |item|
        total_sold += item.quantity
      end
      
      if total_sold > max
        max = total_sold
        max_product = product
      end
    end
    return max_product 
  end
  
  # PRODUCT METHOD TO CALL
  # def total_sold
  #   total_sold = 0
  #   self.order_items.each do |item|
  #     total_sold += item.quantity
  #   end
  # end
  
  def find_orders
    matching_orders = self.products.map{ |prod| prod.order_items }.flatten.map{ |oi| oi.order }.uniq
    return matching_orders
  end
  
  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.username = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    
    return user
  end
  
  def self.list 
    return User.all.order(username: :asc)
  end
end
