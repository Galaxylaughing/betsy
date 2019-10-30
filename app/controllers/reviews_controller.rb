class ReviewsController < ApplicationController
  before_action :find_order, only: [:show]

  def new
    @review = Review.new
  end
  
  def show ; end

  def create
    @review = Review.new(review_params) 
    
    if @review.save
      flash[:success] = "Your review was successfully submited."
      redirect_to root_path
      return
    else
      flash[:failure] = "Your review couldn't be submited."
      redirect_to root_path
      return
    end
  end

end
