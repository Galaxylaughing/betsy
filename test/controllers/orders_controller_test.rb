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
        order_hash = {
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

        expect {
          post orders_path, params: order_hash
        }.must_differ 'Order.count', 1
        must_redirect_to root_path
      end
    end
  end

  describe "Logged in users" do
    before do
      perform_login(users(:begonia))
    end

    it 'creates a new order successfully with valid data while logged in, and redirects the user to the products page' do
      order_hash = {
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

      expect {
        post orders_path, params: order_hash
      }.must_differ 'Order.count', 1
      must_redirect_to root_path
    end
  end
end