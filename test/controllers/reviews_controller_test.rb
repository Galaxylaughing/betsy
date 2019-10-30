require "test_helper"

describe ReviewsController do
  describe 'guest users' do
    describe "index" do
      it "gives back a susccesful response" do
        get orders_path
        must_respond_with :success
      end
      
      it "can get the root path" do
        get root_path
        must_respond_with :success
      end
    end
end
