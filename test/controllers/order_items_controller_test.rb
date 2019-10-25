require "test_helper"

describe OrderItemsController do
  describe "create" do
    let(:product) { products(:begonia)}
    let(:quantity) { 1 }
    let(:order) {Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com")}
    
    it 'creates a new order_item successfully with valid data while not logged in, and redirects the user to the products page' do
      
    end
  end
  
  