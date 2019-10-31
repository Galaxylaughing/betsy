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
  
  # def edit
  #   @category = Category.find_by(id: params[:id])
  
  #   if @category.nil?
  #     flash[:warning] = "Can't edit, invalid category."
  #     redirect_to products_path
  #     return
  #   end
  # end
  
  # def update
  #   user_id = session[:user_id]
  #   @category = Category.find_by(id: params[:id])
  
  #   if @category.update(category_params)
  #     flash[:success] = "Category successfully updated."
  #     redirect_to dashboard_path(user_id)
  #     return
  #   else
  #     flash[:warning] = "Can't update product."
  #     render :edit
  #     return
  #   end
  # end
  
  private
  
  def category_params
    return params.require(:category).permit(:name)
  end
end
