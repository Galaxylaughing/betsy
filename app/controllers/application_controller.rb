class ApplicationController < ActionController::Base
  private
  
  def logged_in?
    user_id = session[:user_id]
    
    if user_id.nil?
      return false
    end
    
    return user_id
  end
end
