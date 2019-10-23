require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      user = users(:begonia)
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      
      expect {
        get callback_path(:github)
      }.wont_change "User.count"
      
      must_redirect_to root_path
      session[:user_id].must_equal user.id
    end
    
    it "creates an account for a new user and redirects to the root route" do
      new_user = User.new(provider: "github", uid: 888444, username: "newbie", email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      expect {
        get callback_path(:github)
      }.must_differ "User.count", 1
      
      must_redirect_to root_path
      session[:user_id].must_equal User.last.id
    end
    
    it "redirects to the login route if given invalid user data" do
      new_user = User.new(provider: "github", uid: 888444, username: "newbie", email: "test@example.com")
      
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_user))
      
      expect {
        get callback_path(:github)
      }.wont_change "User.count"
      
      must_redirect_to root_path
      expect(flash[:error]).wont_be_nil
    end
  end
end