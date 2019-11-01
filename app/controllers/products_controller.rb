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
    
    logged_in_id = logged_in?
    if logged_in_id && @product.user_id != logged_in_id
      flash[:error] = "You cannot edit another merchant's product"
      redirect_to product_path(@product.id)
      return
    end
  end
  
  def update
    user_id = session[:user_id]
    @product = Product.find_by(id: params[:id])
    
    if @product.update(product_params)
      flash[:success] = "Product successfully updated."
      redirect_to dashboard_path(user_id)
      return
    else
      flash[:warning] = "Can't update product."
      render :edit
      return
    end
  end
  
  # Method to retire a product
  def toggle_retire
    user_id = session[:user_id]
    @product = Product.find_by(id: params[:id])
    
    if user_id  
      if @product.available
        @product.update!(available: false)
        
        flash[:success] = "Product #{@product.name} successfully RETIRED."
        redirect_to dashboard_path(user_id)
      else 
        @product.update(available: true)
        flash[:success] = "Product #{@product.name} successfully REACTIVATED."
        redirect_to dashboard_path(user_id)
      end  
      return
    end
  end
  
  private
  
  def product_params
    return params.require(:product).permit(:name, :user_id, :description, :price, :photo_url, :stock, :available, category_ids: [])
  end
end
