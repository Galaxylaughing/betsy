class ReviewsController < ApplicationController
  before_action :find_review, only: [:show]
  
  def index
    @reviews = Review.all
  end
  
  def new
    @review = Review.new
    @product_id = product_id_param
  end
  
  def show
  end
  
  def create
    logged_in_id = logged_in?
    product = Product.find_by(id: product_id_param)
    
    if logged_in_id && logged_in_id == product.user_id
      flash[:error] = "You cannot review your own product"
      redirect_to product_path(product.id)
      return
    else
      review_info = {
        comment: review_params[:comment],
        rating: review_params[:rating],
        product_id: product_id_param
      }
      @review = Review.new(review_info) 
      if @review.save
        flash[:success] = "Your review was successfully submitted."
        redirect_to product_path(product.id)
        return
      else
        flash[:failure] = "Your review couldn't be submitted."
        redirect_to products_path(product.id)
        return
      end
    end
  end
  
  private
  def review_params
    params.require(:review).permit(:rating, :comment)
  end
  
  def product_id_param
    params.require(:product_id)
  end
  
  def find_review
    @review = Review.find_by_id(params[:id])
  end
end
