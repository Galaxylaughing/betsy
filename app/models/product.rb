class Product < ApplicationRecord
  has_many :order_items
  has_many :reviews
  belongs_to :user
  has_and_belongs_to_many :categories
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :photo_url, presence: true
  validates :stock, presence: true
  validates :available, presence: true
  validates :user_id, presence: true
end
