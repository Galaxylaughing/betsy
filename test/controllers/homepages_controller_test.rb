require "test_helper"

describe HomepagesController do
  it "can get the root path" do
    get root_path
    
    must_respond_with :success
  end
  
  it "can get the register-as-merchant page" do
    get register_account_path
    
    must_respond_with :success
  end
end
