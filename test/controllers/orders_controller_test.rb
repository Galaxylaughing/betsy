require "test_helper"

describe OrdersController do
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
    
    describe "show" do
      it "gives back a successful response" do
        order = Order.create
        get order_path(order.id)
        
        must_respond_with :success
      end
    end
    
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
            exp_date: "10/20", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
        
        expect {
          post orders_path, params: order_hash
        }.must_differ 'Order.count', 1
        must_redirect_to root_path
      end
      
      it "takes the date using the regex in order to create the order" do
        
        order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            zip: "98004",
            exp_date: "10/20", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
        
        new_order = Order.create(order_hash[:order])
        new_order.update(address: "Redmond", name: "Georgina", cc_num: "1111111111111111", cvv_code: "123", zip: "98004", exp_date: "abc10/2020", email: "blank@gmail.com", status: "pending")
        updated_order = Order.find_by(id: new_order.id)
        expect(updated_order.exp_date).must_equal "10/20"
      end 
    end
    
    describe "update" do
      before do
        @new_order = Order.create
        @product = products(:orchid)
        @order_item = OrderItem.create(product_id: @product.id, order_id: @new_order.id, quantity: 10)
        
      end
      
      it "updates order status to 'paid' and reduces the stock quantity" do
        order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            zip: "98004", 
            exp_date: "10/20", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
        
        expect { patch order_path(@new_order.id), params: order_hash }.wont_change "Order.count"
        
        updated_order = Order.find(@new_order.id)
        updated_product = Product.find(@product.id)
        
        expect(updated_order.status).must_equal "paid"
        expect(updated_product.stock).must_equal 90
        expect(session[:order_id]).must_be_nil
        must_redirect_to checkout_show_path(updated_order.id)
      end
      
      it "flashes an error with incomplete input" do
        invalid_order = @new_order.update(email: "geob@gmail.com", name: "georgina", address: "bellevue", cvv_code: "111", cc_num: "1111111111111111", exp_date: "10/20")
        
        expect(@new_order.errors.full_messages.to_sentence).must_include "Zip" 
        
        
      end
      
      it 'renders the same page' do
        order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            exp_date: "10/20", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
        
        patch order_path(@new_order.id), params: order_hash
        assert_template :edit
      end
    end
  end
  
  
  describe "Logged in users" do
    before do
      perform_login(users(:begonia))
    end
    
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
    
    describe "show" do
      it "gives back a successful response" do
        order = Order.create
        get order_path(order.id)
        must_respond_with :success
      end
    end
    
    describe "create" do
      it 'creates a new order successfully with valid data while logged in, and redirects the user to the products page' do
        order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            zip: "98004", 
            email: "blank@gmail.com",
            exp_date: "10/20",
            status: "pending"
          }
        }
        
        expect {
          post orders_path, params: order_hash
        }.must_differ 'Order.count', 1
        must_redirect_to root_path
      end
      
      describe "show" do
        it "gives back a successful response" do
          order = Order.create(address: "Redmond", name: "Georgina", cc_num: "1111111111111111", cvv_code: "123", zip: "98004", email: "blank@gmail.com", status: "pending")
          get order_path(order.id)
          must_respond_with :success
        end
      end
      
      describe "create" do
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
    
    describe "update" do
      before do
        @new_order = Order.create
        @product = products(:orchid)
        @order_item = OrderItem.new(product_id: @product.id, order_id: @new_order.id, quantity: 10)
        
      end
      
      it "updates order status to 'paid', and reduce available stock upon purchase" do
        order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            zip: "98004", 
            exp_date: "10/20", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
        
        expect { patch order_path(@new_order.id), params: order_hash }.wont_change "Order.count"
        
        updated_order = Order.find(@new_order.id)
        updated_product = Product.find(@product.id)
        
        expect(updated_order.status).must_equal "paid"
        #expect(updated_product.stock).must_equal 90
        must_redirect_to checkout_show_path(updated_order.id)
      end
      
      it "flashes an error with incomplete input" do
        invalid_order = @new_order.update(email: "geob@gmail.com", name: "georgina", address: "bellevue", cvv_code: "111", cc_num: "1111111111111111", exp_date: "10/20")
        
        expect(@new_order.errors.full_messages.to_sentence).must_include "Zip" 
        
        
      end
      
      it 'renders the same page' do
        order_hash = {
          order: {
            address: "Redmond", 
            name: "Georgina", 
            cc_num: "1111111111111111", 
            cvv_code: "123", 
            exp_date: "10/20", 
            email: "blank@gmail.com",
            status: "pending"
          }
        }
        
        patch order_path(@new_order.id), params: order_hash
        assert_template :edit
      end
    end
  end
end
