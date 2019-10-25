require "test_helper"

describe OrdersController do
  describe "index" do
    it "gives back a susccesful response" do
      get passengers_path

      must_respond_with :success
    end

    it "can get the root path" do
      get root_path
      must_respond_with :success
    end
  end
end