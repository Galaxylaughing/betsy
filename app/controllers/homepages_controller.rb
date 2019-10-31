class HomepagesController < ApplicationController
  def register
    if logged_in?
      flash[:error] = "You've already signed up!"
      redirect_to root_path
      return
    end
  end
  
  def about; end
end
