class Product < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :user
  has_and_belongs_to_many :categories
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: {only_float: true, greater_than: 0}
  validates :photo_url, presence: true
  validates :stock, presence: true, numericality: {only_integer: true}
  validates_inclusion_of :available, in: [true, false] 
  validates :user_id, presence: true
  
  def available_stock(order_id)
    order = Order.find_by(id: order_id)
    return self.stock if order.nil?
    order.order_items.each do |oi|
      if oi.product_id == self.id
        return self.stock - oi.quantity.to_i
      end  
    end
    return self.stock 
  end
  
  def calculate_average_rating
    reviews = self.reviews
    
    if reviews.blank?
      average_rating = nil
    else
      product_ratings = []
      
      reviews.each do |review|
        product_ratings << review.rating
      end
      
      total_rating = product_ratings.sum
      average_rating = total_rating / product_ratings.length
    end
    
    return average_rating
  end
  
  def self.sample_products_for_homepage()
    product_list = Product.order(Arel.sql("RANDOM()")).to_a
    
    sample_products_list = []
    
    while sample_products_list.length < 5 && !product_list.empty?
      product = product_list.pop()
      
      if product.available == true
        sample_products_list << product
      end
    end
    
    return sample_products_list
  end
end
