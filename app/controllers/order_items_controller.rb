class OrderItemsController < ApplicationController
  
  
  def create
    if session[:order_id].nil?
      order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com")
      session[:order_id] = order.order_id
    end
    
    order_items = {
      product_id = params[:product_id]
      quantity = params[:quantity]
      order_id = session[:order_id]
    }
    
    OrderItem.create(order_items)
  end
  
  private
  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end
end
