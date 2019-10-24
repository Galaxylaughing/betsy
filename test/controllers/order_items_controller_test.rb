require "test_helper"

describe OrderItemsController do
  describe "Create" do
    let(:product) { products(:begonia) }
    let(:quantity) { 1 }
    let(:order) { Order.create!(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com") }
    
    it 'creates a new order_item successfully with valid data when a user is not logged in, and redirects the user to the product page' do
      expect {
        post 
      }
    end
  end
end

