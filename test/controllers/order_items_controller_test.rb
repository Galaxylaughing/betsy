require "test_helper"

describe OrderItemsController do
  describe 'guest users' do
    describe "create" do
      before do
        @user = User.create(username: "georgina", email: "geor@gmail.com")
        @product_cactus = Product.create(user_id: @user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
        @product_flower = Product.create(user_id: @user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
        @order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com", exp_date: "10/20")
        @order_item_hash = {
          order_item: {
            product_id: @product_cactus.id,
            quantity: 3,
            order_id: @order.id,
          }
        }
      end
      
      it 'creates a new order_item successfully with valid data while not logged in, and redirects the user to the products page' do
        expect {
          post order_items_path, params: @order_item_hash[:order_item]
        }.must_differ 'OrderItem.count', 1
        
        must_redirect_to product_path(@product_cactus.id)
      end
      
      it 'does not create a new order_item given invalid data while not logged in, and redirects the user to the products page' do
        invalid_item_hash = {
          order_item: {
            product_id: @product_cactus.id,
            order_id: @order.id,
          }
        }
        expect {
          post order_items_path, params: invalid_item_hash[:order_item]
        }.must_differ 'OrderItem.count', 0
        
        must_redirect_to product_path(@product_cactus.id)
      end
    end
    
    describe 'delete' do
      before do
        @user = User.create(username: "georgina", email: "geor@gmail.com")
        @product_cactus = Product.create(user_id: @user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
        @product_flower = Product.create(user_id: @user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
        @order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com", exp_date: "10/20")
      end
      
      it 'can delete an order_item successfully while not logged in' do
        new_order_item = OrderItem.create(product_id: @product_cactus.id, quantity: 3, order_id: @order.id,)
        expect {
          delete order_item_path(new_order_item.id)
        }.must_change 'OrderItem.count', 1
      end
    end
    
    describe 'update' do
      before do
        @user = User.create(username: "georgina", email: "geor@gmail.com")
        @product_cactus = Product.create(user_id: @user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
        @product_flower = Product.create(user_id: @user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
        @order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com", exp_date: "10/20")
        @new_order_item = OrderItem.create(product_id: @product_cactus.id, quantity: 3, order_id: @order.id,)
        @updated_order_item_hash = {
          order_item: {
            product_id: @product_cactus.id,
            quantity: 5,
            order_id: @order.id,
          }
        }
      end
      
      it 'cannot add more items to cart than are available in stock' do
        @updated_order_item_hash[:order_item][:quantity] = 500
        
        expect{ 
          patch "/products/#{@product_cactus.id}/order_items/#{@new_order_item.id})", params: @updated_order_item_hash
        }.wont_differ "@order.order_items.count"
        
        expect(@order.errors).wont_be_nil
        
      end
      
      it "can update an existing order_item while not logged in" do
        patch "/products/#{@product_cactus.id}/order_items/#{@new_order_item.id})", params: @updated_order_item_hash
        
        expect(OrderItem.find_by(id: @new_order_item.id).quantity).must_equal 5
      end
    end
    
    describe "complete" do
      it "does not effect the status" do
        oi = order_items(:bear_treeivy)
        oi_status = oi.status
        
        expect {
          post mark_complete_path(oi.id)
        }.wont_differ "OrderItem.count"
        
        expect(OrderItem.find_by(id: oi.id).status).must_equal oi_status
      end
    end
  end
  
  describe "Logged in users" do
    before do
      perform_login(users(:begonia))
    end
    
    describe "create" do
      before do
        @user = User.create(username: "georgina", email: "geor@gmail.com")
        @product_cactus = Product.create(user_id: @user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
        @product_flower = Product.create(user_id: @user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
        @order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com", exp_date: "10/20")
        @order_item_hash = {
          order_item: {
            product_id: @product_cactus.id,
            quantity: 3,
            order_id: @order.id,
          }
        }
      end
      
      it 'creates a new order_item successfully with valid data while logged in, and redirects the user to the product page' do
        
        expect {
          post order_items_path, params: @order_item_hash[:order_item]
        }.must_differ 'OrderItem.count', 1
        must_redirect_to product_path(@product_cactus.id)
      end
      
      it 'does not create a new order_item given invalid data while logged in, and redirects the user to the products page' do
        invalid_item_hash = {
          order_item: {
            product_id: @product_cactus.id,
            order_id: @order.id,
          }
        }
        expect {
          post order_items_path, params: invalid_item_hash[:order_item]
        }.must_differ 'OrderItem.count', 0
        
        must_redirect_to product_path(@product_cactus.id)
      end
    end
    
    describe 'delete' do
      before do
        @user = User.create(username: "georgina", email: "geor@gmail.com")
        @product_cactus = Product.create(user_id: @user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
        @product_flower = Product.create(user_id: @user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
        @order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com", exp_date: "10/20")
      end
      
      it 'can delete an order_item successfully while logged in' do
        new_order_item = OrderItem.create(product_id: @product_cactus.id, quantity: 3, order_id: @order.id,)
        expect {
          delete "/products/#{@product_cactus.id}/order_items/#{new_order_item.id}"
        }.must_change 'OrderItem.count', 1
      end
    end
    
    describe 'update' do
      before do
        @user = User.create(username: "georgina", email: "geor@gmail.com")
        @product_cactus = Product.create(user_id: @user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
        @product_flower = Product.create(user_id: @user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
        @order = Order.create(address: "x", name: "x", cc_num: "x", cvv_code: "x", zip: "x", email: "blank@blank.com", exp_date: "10/20")
        @order = Order.create
        @new_order_item = OrderItem.create(product_id: @product_cactus.id, quantity: 3, order_id: @order.id,)
        @updated_order_item_hash = {
          order_item: {
            product_id: @product_cactus.id,
            quantity: 5,
            order_id: @order.id,
          }
        }
      end
      it "can update an existing order_item while logged in" do
        patch "/products/#{@product_cactus.id}/order_items/#{@new_order_item.id})", params: @updated_order_item_hash
        
        expect(OrderItem.find_by(id: @new_order_item.id).quantity).must_equal 5
      end
    end
    
    describe "complete" do
      it "changes the status to complete" do
        user = users(:orchid)
        perform_login(user)
        
        oi = order_items(:bear_treeivy)
        oi_status = oi.status
        
        expect {
          post mark_complete_path(oi.id)
        }.wont_differ "OrderItem.count"
        
        must_redirect_to dashboard_path(user.id)
        expect(OrderItem.find_by(id: oi.id).status).must_equal "complete"
      end
      
      it "is idempotent" do
        user = users(:orchid)
        perform_login(user)
        
        oi = order_items(:bear_treeivy)
        oi_status = oi.status
        
        post mark_complete_path(oi.id)
        post mark_complete_path(oi.id)
        
        must_redirect_to dashboard_path(user.id)
        expect(OrderItem.find_by(id: oi.id).status).must_equal "complete"
      end
    end
  end
end
