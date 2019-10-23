class Order < ApplicationRecord
  has_many :order_items

  validates :address, :name, :cc_num, :cvv_code, :zip, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
