class Product < ApplicationRecord
  has_many :order_items
  has_many :reviews
  belongs_to :user
  has_and_belongs_to_many :categories
end
