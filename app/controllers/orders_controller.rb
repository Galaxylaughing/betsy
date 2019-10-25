class OrdersController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]

  def new
    @order = Order.new
  end

  def index
    @orders = Order.all
  end
  
  def show ; end

  def edit ; end

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

  def update
    if session[:order_id] != nil
    end
  end


private
  def order_params
    params.require(:order).permit(:email, :address, :name, :cc_num, :cvv_code, :zip)
  end

  def find_order
    @order = Order.find_by_id(params[:id])
  end
end
