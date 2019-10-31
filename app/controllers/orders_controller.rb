class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :update, :destroy]
  
  def new
    @order = Order.new
  end
  
  def index
    @orders = Order.all
  end
  
  def show ; end
  
  def edit ; end
  
  def update
    if @order.update(order_params)
      @order.status = "paid"
      
      session[:order_id] = nil
      @order.update_stock
      @order.save
      
      flash[:success] = "Your order is complete. Thank you for shopping at Plantsy!"
      
      redirect_to checkout_show_path(@order.id)
    else
      flash[:error] = @order.errors.full_messages  
      render :edit
    end
  end
  
  def create
    @order = Order.new(order_params) 
    if @order.save
      session[:order_id] = @order.id
      flash[:success] = "Your order has been processed" 
      redirect_to root_path
      return
    else
      render :new
      return
    end
  end
  
  # def checkout_show
  # end
  
  private
  def order_params
    params.require(:order).permit(:email, :address, :name, :cc_num, :cvv_code, :exp_date, :zip)
  end
  
  def find_order
    @order = Order.find_by_id(params[:id])
    
    if @order.nil?
      redirect_to request.referrer
    end  
  end
end
