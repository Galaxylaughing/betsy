class UsersController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    
    # user = User.find_by(uid: auth_hash[:uid], provider: "github")
    
    # you need this to be able to login as a seed
    # otherwise, you'll get an 'email already in use' error
    user = User.find_by(email: auth_hash[:info][:email])
    
    if user
      flash[:success] = "Successfully logged in as returning user #{user.username}"
    else
      user = User.build_from_github(auth_hash)
      
      if user.save
        flash[:success] = "Successfully logged in as new user #{user.username}"
      else
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        redirect_to root_path
        return
      end
    end
    
    session[:user_id] = user.id
    redirect_to dashboard_path(user.id)
    return
  end
  
  def destroy
    if session[:user_id]
      session[:user_id] = nil
      flash[:success] = "Successfully logged out!"
    else
      flash[:error] = "No one logged in"
    end
    
    redirect_to root_path
  end
  
  def index
    @users = User.list
  end
  
  def show
    @user = get_user
  end
  
  def dashboard
    # the person logged in
    logged_in_id = logged_in?
    # the person to whom the dashboard belongs
    user = get_user
    
    # if the dashboard owner and the logged-in user are the same
    if logged_in_id && (user.id == logged_in_id)
      @user = user
    elsif logged_in_id
      # don't let a merchant see the dashboard of another merchant
      flash[:error] = "Permission denied: you cannot view another merchant's dashboard"
      redirect_to users_path
    else
      # don't let a guest see a merchant dashboard
      flash[:error] = "Permission denied: please log in to view your dashboard"
      redirect_to users_path
    end
  end
  
  private
  
  def get_user
    user = User.find_by(id: params[:id])
    
    if user.nil?
      flash[:error] = "Could not find user with id: #{params[:id]}"
      redirect_to users_path
      return
    end
    
    return user
  end
end
