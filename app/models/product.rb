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
    order = Order.find(order_id)
    
    if order_id.nil? || order.order_items.count == 0
      return self.stock
    else
      
      order.order_items.each do |oi|
        if oi.product_id == self.id
          return self.stock - oi.quantity.to_i
        end
      end
    end
  end
  
  def self.sample_products_for_homepage()
    return Product.order(Arel.sql("RANDOM()")).limit(5)
  end
end
