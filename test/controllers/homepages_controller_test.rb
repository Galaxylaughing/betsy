require "test_helper"

describe HomepagesController do
  it "can get the root path" do
    get root_path
    
    must_respond_with :success
  end
  
  describe "register as merchant" do
    it "can get the register-as-merchant page" do
      get register_account_path
      
      must_respond_with :success
    end
    
    it "can't be accessed if you're logged in" do
      perform_login()
      
      get register_account_path
      
      must_redirect_to root_path
      expect(flash[:error]).must_equal "You've already signed up!"
    end
  end
end
