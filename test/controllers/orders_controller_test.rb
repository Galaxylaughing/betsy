require "test_helper"

describe OrdersController do
  describe 'guest users' do
    describe "create" do
      before do
        @order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            zip: "98004", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
      end

      it 'creates a new order successfully with valid data while not logged in, and redirects the user to the products page' do
        expect {
          post orders_path, params: @order_hash[:order]
        }.must_differ 'Order.count', 1
        
        must_redirect_to root_path
      end
    end
  end
end