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
    
    if max_product.nil? || max_product.count_sold == 0
      max_product = nil
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
    matching_orders = self.products.flat_map{ |prod| prod.order_items }.map{ |oi| oi.order }.uniq
    return matching_orders
  end
  
  def total_revenue_by_order(order_id)
    order = Order.find(order_id)
    total_cost = self.order_revenue(order)
    return total_cost
  end
  
  def order_revenue(order)
    total_per_order = 0
    order.order_items.each do |oi|
      product = Product.find_by(id: oi.product_id)
      if product.user_id == self.id
        total_per_order += oi.subtotal
      end
    end
    return total_per_order
  end
  
  def total_revenue()
    orders = self.find_orders
    
    total_cost = 0.0
    orders.each do |order|
      total_cost += self.order_revenue(order)
    end
    
    return total_cost
  end
  
  # I want the total revenue for a set of orders based on status
  # I have find_orders_by_status, which will return a list of orders by status.
  # Then I need to find the total revenue for each of those orders, for my merchant
  def total_revenue_by_status(status)
    all_orders = self.find_orders_by_status(status)
    
    total_revenue = 0.0
    if all_orders
      all_orders.each do |order|
        total_revenue += total_revenue_by_order(order.id)
      end
    end
    
    return total_revenue
  end
  
  def find_orders_by_status(status)
    if status == :all
      return self.find_orders
    else
      orders_by_status = self.sort_orders_by_status()
      return orders_by_status[status]
    end
  end
  
  def get_order_status(order)
    result = find_order_statuses()
    return result[:status_for_orders][order.id]
  end
  
  def sort_orders_by_status()
    result = find_order_statuses()
    return result[:orders_by_status]
  end
  
  def find_order_statuses()
    orders = self.find_orders()
    
    orders_by_status = {}
    status_for_orders = {}
    
    orders.each do |order|
      # create a hash of this order's statuses
      oi_statuses = {}
      # start a count of this merchant's order items
      oi_count = 0
      order.order_items.each do |oi|
        product = Product.find_by(id: oi.product_id)
        # if the oi belongs to this merchant
        if product.user_id == self.id
          # iterate the count of this merchant's order items
          oi_count += 1
          # add order item status to hash
          oi_status = oi.status.to_sym
          if oi_statuses[oi_status]
            oi_statuses[oi_status] += 1
          else
            oi_statuses[oi_status] = 1
          end
          # add order item status to possible order statuses hash
          if orders_by_status[oi_status].nil?
            orders_by_status[oi_status] = []
          end # if nil?
        end # if user orderitem
      end # each orderitem
      
      # now there's hash of the statuses of the order_items
      # calculate the order status based on that
      if oi_count == oi_statuses[:complete]
        # if all members are complete, the order is complete
        status = :complete
      elsif oi_count == oi_statuses[:cancelled]
        # if all members are cancelled, the order is cancelled
        status = :cancelled
      elsif oi_count == oi_statuses[:paid]
        # if all members are paid, the order is paid
        status = :paid
      elsif oi_statuses[:cancelled] && oi_statuses[:complete] && oi_statuses[:paid].blank? && oi_statuses[:pending].blank?
        # if some members are complete and some cancelled, the order is complete
        status = :complete
      elsif oi_statuses[:paid] && oi_statuses[:complete] && oi_statuses[:cancelled].blank? && oi_statuses[:pending].blank?
        # if some members are paid and some are complete, the order is paid
        status = :paid
      else
        # if all members are pending, the order is pending
        status = :pending
      end
      
      orders_by_status[status] << order
      status_for_orders[order.id] = status
    end
    
    result = {
      orders_by_status: orders_by_status,
      status_for_orders: status_for_orders,
    }
    
    return result
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
