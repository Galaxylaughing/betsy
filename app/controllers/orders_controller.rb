class OrdersController < ApplicationController
  before_action :find_book, only: [:show, :edit, :update, :destroy]

  def new
    @order = Order.new
  end

  def index
    @orders = Order.all
  end

  # def create
  #   if session[:user_id].nil?
  #     flash[:failure] = {general:"A problem occurred: You must log in to do that"}
  #     redirect_to works_path
  #   else
  #     vote_info = {
  #       date: Time.now,
  #       user_id: session[:user_id],
  #       work_id: work_id
  #     }
  #     if Vote.where(user_id: session[:user_id], work_id: work_id).exists?
  #       flash[:failure] = {general:"A problem occurred: Could not upvote", user: "user: has already voted for this work"}
  #       redirect_to works_path
  #     else
  #       @vote = Vote.new(vote_info) 
  #       if @vote.save
  #         flash[:success] = "Successfully upvoted" 
  #         redirect_to works_path
  #         return
  #       else
  #         render :new
  #         return
  #       end
  #     end
  #   end
  # end


private
  def find_order
    @order = Order.find_by_id(params[:id])
  end
end
