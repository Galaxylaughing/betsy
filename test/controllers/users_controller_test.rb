require "test_helper"

describe UsersController do
  describe "create" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:begonia)
      
      perform_login(user)
      
      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(flash[:success]).must_include "Successfully logged in as returning user"
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 888444, username: "newbie", email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      get callback_path(:github)
      
      must_redirect_to root_path
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
      let(:user) { users(:begonia) }
      it "can see the merchant index" do
        perform_login(user)
        
        get users_path
        
        must_respond_with :success
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
  end
end