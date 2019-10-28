require "test_helper"

describe UsersController do
  describe "create" do
    it "logs in an existing user and redirects to the dashboard" do
      start_count = User.count
      user = users(:begonia)
      
      perform_login(user)
      
      must_redirect_to dashboard_path(user.id)
      expect(session[:user_id]).must_equal user.id
      expect(flash[:success]).must_include "Successfully logged in as returning user"
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the dashboard" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 888444, username: "newbie", email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      get callback_path(:github)
      
      must_redirect_to dashboard_path(User.last.id)
      expect(session[:user_id]).must_equal User.last.id
      expect(flash[:success]).must_include "Successfully logged in as new user"
      expect(User.count).must_equal start_count + 1
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 888444, email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      get callback_path(:github)
      
      must_redirect_to root_path
      expect(flash[:error]).wont_be_nil
      expect(User.count).must_equal start_count
    end
  end
  
  describe "Logged in users" do
    describe "destroy" do
      it "logs out a user" do
        start_count = User.count
        user = users(:begonia)
        
        perform_login(user)
        # check that there is a logged in user to log out
        expect(session[:user_id]).must_equal user.id
        
        delete logout_path
        
        must_redirect_to root_path
        expect(session[:user_id]).must_be_nil
        expect(flash[:success]).must_equal "Successfully logged out!"
        # make sure the user did not get deleted from the database
        expect(User.count).must_equal start_count
      end
    end
    
    describe "index" do
      it "can see the merchant index" do
        user = users(:begonia)
        
        perform_login(user)
        
        get users_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "can see the product-by-merchant list page" do
        user = users(:begonia)
        
        get user_path(user)
        
        must_respond_with :success
      end
    end
    
    describe "dashboard" do
      it "can be viewed by its own merchant" do
        user = users(:begonia)
        perform_login(user)
        
        get dashboard_path(user)
        
        must_respond_with :success
      end
      
      it "can't be viewed by another merchant" do
        begonia = users(:begonia)
        orchid = users(:orchid)
        
        perform_login(begonia)
        
        get dashboard_path(orchid)
        
        must_respond_with :redirect
        must_redirect_to users_path
        expect(flash[:error]).must_equal "Permission denied: you cannot view another merchant's dashboard"
      end
    end
    
    describe "edit" do
      it "can be seen by a logged in user" do
        user = users(:begonia)
        perform_login(user)
        
        get edit_user_path(user)
        
        must_respond_with :success
      end
      
      it "can't be seen by a different logged-in user" do
        user = users(:begonia)
        other_user = users(:orchid)
        
        perform_login(user)
        
        get edit_user_path(other_user)
        
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:error]).must_equal "Permission denied: you cannot edit another merchant's profile"
      end
    end
  end
  
  describe "Guest users" do
    describe "destroy" do
      it "doesn't effect an logged-out user" do
        start_count = User.count
        
        delete logout_path
        
        expect(session[:user_id]).must_be_nil
        expect(flash[:success]).must_be_nil 
        expect(flash[:error]).must_equal "No one logged in"   
        expect(User.count).must_equal start_count
      end
    end
    
    describe "index" do
      it "can see the merchant index" do
        get users_path
        
        must_respond_with :success
      end
    end
    
    describe "show" do
      it "can see the product-by-merchant list page" do
        user = users(:begonia)
        
        get user_path(user)
        
        must_respond_with :success
      end
    end
    
    describe "dashboard" do
      it "cannot be viewed by a guest" do
        user = users(:begonia)
        
        get dashboard_path(user)
        
        must_respond_with :redirect
        must_redirect_to users_path
        expect(flash[:error]).must_equal "Permission denied: please log in to view your dashboard"
      end
    end
    
    describe "edit" do
      it "can't be seen by a guest user'" do
        user = users(:begonia)
        
        get edit_user_path(user)
        
        must_respond_with :redirect
        must_redirect_to root_path
        expect(flash[:error]).must_equal "Permission denied: please log in"
      end
    end
  end
end
