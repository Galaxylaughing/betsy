class ProductsController < ApplicationController
  def index 
    @products = Product.all
  end
  
  def show
    @order = session[:order_id] # added for custom method in model
    product_id = params[:id]
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      flash[:error] = "Invalid product."
      redirect_to products_path
      return
    end
    # if session[:user_id] && session[:user_id] == @product.user_id
    #   render :user_show
    # end
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params) 
    
    if @product.save
      flash[:success] = "Product successfully created."
      redirect_to product_path(@product.id)
      return
    else
      flash[:warning] = "Can't create product."
      redirect_to products_path
      return
    end
  end 
  
  def edit
    @product = Product.find_by(id: params[:id])
    
    if @product.nil?
      flash[:warning] = "Can't edit, invalid product."
      redirect_to products_path
      return
    end
  end
  
  def update
    @product = Product.find_by(id: params[:id])
    
    if @product.update(product_params)
      flash[:success] = "Product successfully updated."
      redirect_to product_path(@product.id)
      return
    else
      flash[:warning] = "Can't update product."
      render :edit
      return
    end
  end
  
  def retire
    user_id = logged_in?
    
    if user_id
      product_id = params[:id]
      product_id = Product.find_by(id: product_id)
      
      product.available = false
      
      if product.save
        flash[:success] = "Product successfully retired."
        redirect_to dashboard_path(user_id)
      else 
        flash[:warning] = "Can't retire product."
        redirect_to dashboard_path(user_id)
      end  
      return
    end
  end
  
  private
  
  def product_params
    return params.require(:product).permit(:name, :user_id, :description, :price, :photo_url, :stock, :available)
  end
end
