class User < ApplicationRecord
  has_many :products
  
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  def order_count
    order_total = 0
    self.products.each do |product|
      
      # come back to this and extract it to a Product method    
      # call this instead:
      # orders = product.orders
      orders = {}
      product.order_items.each do |order_item|
        if orders[order_item.order_id].nil?
          orders[order_item.order_id] = true
        end
      end
      
      order_total += orders.count
    end
    return order_total
  end
  
  # do I really care if there's a tie?
  # def top_product
  #  max = 0
  #  max_product = nil
  #  tie_items = []
  #  self.products.each do |product|
  #    total_sold = product.total_sold
  #    if total_sold > max
  #      max = total_sold
  #      max_product = product
  #      # reset tie_items
  #      tie_items = []
  #    elsif total_sold == max
  #      tie = true
  #      tie_items << [product]
  #    end
  #  end
  # if tie_items.length > 0
  #   # find tie item with the most order_items
  # end
  # return max_product 
  # end
  
  # PRODUCT METHOD TO CALL
  # def total_sold
  #   total_sold = 0
  #   self.order_items.each do |item|
  #     total_sold += item.quantity
  #   end
  # end
  
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
