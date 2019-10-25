class OrderItemsController < ApplicationController
  before_action :find_order_item, only: [:show, :edit, :update, :destroy]
  
  # Create is adding a product to my cart
  def create
    if session[:order_id].nil?
      order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com")
      session[:order_id] = order.id
    end
    
    order_items = {
      product_id: params[:product_id],
      quantity: params[:quantity],
      order_id: session[:order_id],
    }
    
    order_item = OrderItem.new(order_items)
    if order_item.save
      flash[:success] = "Successfully added item to your cart."
      redirect_to products_path
    else
      
      flash.now[:failure] = "Failure: Item could not be added to your cart."
      redirect_to product_path(order_items[:product_id])
    end
    
  end

  #Delete is going to be "remove products from my cart."

  def destroy
    @order_item.destroy

    redirect_to products_path
  end

  #Update is going to change the quantity of my cart."

  def update
    if @order_item.update(order_items_params)
      redirect_to root_path 
      return
    else 
      render :edit
      return
    end
  end

  
  private
  def order_items_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
end
