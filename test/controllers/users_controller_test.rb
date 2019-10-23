require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count
      user = users(:begonia)
      
      perform_login(user)
      get callback_path(:github)
      
      # must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      expect(User.count).must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 888444, username: "newbie", email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      get callback_path(:github)
      
      # must_redirect_to root_path
      expect(session[:user_id]).must_equal User.last.id
      expect(User.count).must_equal start_count + 1
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count
      new_user = User.new(provider: "github", uid: 888444, email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      get callback_path(:github)
      
      # must_redirect_to root_path
      expect(flash[:error]).wont_be_nil
      expect(User.count).must_equal start_count
    end
  end
end