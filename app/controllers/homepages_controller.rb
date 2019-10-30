class HomepagesController < ApplicationController
  def register
    if logged_in?
      flash[:error] = "You've already signed up!"
      redirect_to root_path
      return
    end
  end
  
  private
  
  def logged_in?
    user_id = session[:user_id]
    
    if user_id.nil?
      return false
    end
    
    return user_id
  end
end
