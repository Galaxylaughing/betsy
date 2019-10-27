class CategoriesController < ApplicationController
  def index
    @categories = Category.order(:name)
  end
  
  def edit
  end
  
  def create
  end
end
