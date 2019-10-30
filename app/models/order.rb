class Order < ApplicationRecord
  has_many :order_items
  
  validates :address, :name, :cc_num, :cvv_code, :zip, presence: true, on: :update
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: :update
  validates :exp_date, format: { with: /.*(\d{2}).*(\d{2})/ }, on: :update, presence: true
  
  def total
    total = 0
    self.order_items.each do |oi|
      total += oi.subtotal
    end
    
    return total
  end
  
end
