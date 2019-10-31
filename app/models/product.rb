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
  validates :available, presence: true
  validates :user_id, presence: true
  
  # def self.sort_by_category(category)
  #   self.where(category: category)
  # end
  
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
    return Product.order(Arel.sql("RANDOM()")).limit(5)
  end
end
