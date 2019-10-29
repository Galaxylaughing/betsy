class UsersController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    
    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    
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
  
  def login_form
    @user = User.new
  end
  
  def login
    username = params[:user][:username]
    
    user = User.find_by(username: username)
    if user
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as returning user #{username}"
    else
      flash[:error] = "Please try again"
      redirect_to root_path
      return
    end
    
    redirect_to dashboard_path(user.id)
  end
  
  def logout
    session[:user_id] = nil
    redirect_to root_path
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
  
  def logged_in?
    user_id = session[:user_id]
    
    if user_id.nil?
      return false
    end
    
    return user_id
  end
end
