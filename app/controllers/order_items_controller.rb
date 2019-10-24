class OrderItemsController < ApplicationController
  
  
  def create
    if session[:order_id].nil?
      order = Order.create(status: "pending")
      
    end
  end
  