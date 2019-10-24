class OrderItemsController < ApplicationController
  
  
  def create
    if session[:order_id].nil?
      order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com")
      session[:order_id] = order.id
    end
    
    order_items = {
      product_id = params[:product_id]
      quantity = params[:quantity]
      order_id = session[:order_id]
    }
    
    order_item = OrderItem.new(order_items)
    
    if order_item.save
      flash[:success] = "Successfully added item to your cart."
      redirect_to products_path
    else
      flash.now[:failure] = "Failure: Item could not be added to your cart."
      render :new
    end
  end
  
  private
  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end
end
