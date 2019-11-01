class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end
  
  def new
    @category = Category.new
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
