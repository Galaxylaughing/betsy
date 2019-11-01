class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end
  
  def new
    logged_in_id = logged_in?
    if !logged_in_id
      flash[:error] = "A guest cannot create a category."
      redirect_to products_path
      return
    else
      @category = Category.new
    end
  end
  
  def create
    user_id = session[:user_id]
    @category = Category.new(category_params) 
    
    if @category.save
      flash[:success] = "Category successfully created."
      redirect_to dashboard_path(user_id)
      return
    else
      flash[:warning] = "Can't create category."
      redirect_to dashboard_path(user_id)
      return
    end
  end
  
  private
  
  def category_params
    return params.require(:category).permit(:name)
  end
end
