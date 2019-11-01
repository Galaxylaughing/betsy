require "test_helper"

describe ProductsController do
  
  before do
    @user = User.create(username: "test user", email: "test_email@example.com") 
    @category1 = Category.create(name: "flower")
    @category2 = Category.create(name: "specialty")
    @product = Product.create(user_id: @user.id, name: "test product", description: "cool product", price: 1.99, photo_url: "url", stock: 3)
    
    @review1 = Review.create(product_id: @product.id, rating: 5, comment: "great product")
    @review2 = Review.create(product_id: @product.id, rating: 2, comment: "bad product")
    
    @order = Order.create(email: "test email", address: "test address", name: "test user name", cc_num: 1234, zip: 98111)
    @order_item1 = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity: 2)
    @order_item2 = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity: 4)
  end
  
  describe "Logged in users" do
    before do
      perform_login(users(:begonia))
    end
    
    describe "index" do
      it "gives back success when products saved" do
        get products_path
        must_respond_with :success
      end 
      
      it "can get the root path" do
        get root_path
        must_respond_with :success
      end
      
      it "responds with sucess when no products saved" do
        Product.destroy_all
        
        expect(Product.count).must_equal 0
        get products_path
        must_respond_with :success
      end
    end 
    
    describe "show" do
      it "can get a valid product" do 
        get product_path(@product.id)
        must_respond_with :success
      end 
      
      it "will redirect for an invalid product id" do
        get product_path(-1111)
        must_redirect_to products_path
      end
    end  
    
    describe "new" do 
      it "can get the new product page" do
        get new_product_path
        must_respond_with :success
      end
    end
    
    describe "create" do
      it "can create a new product with valid information" do 
        product_hash = {
          product: {
            user_id: @user.id,
            name: "new product",
            description: "new description",
            price: 1.99,
            stock: 49,
            photo_url: "new_photo url"
          }
        }
        
        expect {
          post products_path, params: product_hash
        }.must_change "Product.count", 1
        
        new_product = Product.find_by(name: product_hash[:product][:name])  
        expect(new_product.price).must_equal product_hash[:product][:price]
        expect(new_product.stock).must_equal product_hash[:product][:stock]
        expect(new_product.photo_url).must_equal product_hash[:product][:photo_url]
        expect(new_product.description).must_equal product_hash[:product][:description]
        
        must_respond_with :redirect
        must_redirect_to product_path(new_product.id)
      end 
    end 
    
    describe "edit" do
      it "can get the edit page for an existing product" do
        user = users(:orchid)
        # hollyhock is orchid's product
        product = products(:hollyhock)
        
        perform_login(user)
        get edit_product_path(product.id)
        
        must_respond_with :success
      end
      
      it "cannot get the edit page for someone else's product" do
        user = users(:orchid)
        # treeivy is begonia's product
        product = products(:treeivy)
        
        perform_login(user)
        get edit_product_path(product.id)
        
        must_redirect_to product_path(product.id)
        expect(flash[:error]).must_equal "You cannot edit another merchant's product"
      end
      
      it "won't edit an invalid product id and redirect" do
        get edit_product_path(-111)
        must_respond_with :redirect
      end
    end
    
    describe "update" do 
      it "can update an existing product" do  
        updated_product_hash = {
          product: {
            user_id: @user.id,
            name: "updated product",
            description: "updated description",
            price: 2.00,
            stock: 50,
            photo_url: "updated photo_url"
          } 
        } 
        
        expect {
          patch product_path(@product.id), params: updated_product_hash
        }.wont_change "Product.count"
        
        expect(Product.find_by(id: @product.id).name).must_equal "updated product"
        expect(Product.find_by(id: @product.id).description).must_equal "updated description"
        expect(Product.find_by(id: @product.id).photo_url).must_equal "updated photo_url"
        expect(Product.find_by(id: @product.id).price).must_equal 2.00
        expect(Product.find_by(id: @product.id).stock).must_equal 50
        
        must_respond_with :redirect
        must_redirect_to dashboard_path(users(:begonia).id)
      end 
      
      it "can't update an existing product with wrong params" do  
        bad_product_hash = {
          product: {
            user_id: @user.id,
            name: nil,
            description: nil,
            price: nil,
            stock: nil,
            photo_url: nil
          } 
        }
        
        patch product_path(@product.id), params: bad_product_hash
        expect(Product.find_by(id: @product.id).name).must_equal "test product"
      end  
      
      it "will redirect to the root page if given an invalid id" do
        get product_path(-1)
        must_respond_with :redirect
      end
    end
    
    describe "toggle" do
      it "retires a product" do
        product = products(:orchid)
          patch retired_path(product.id)
        expect(Product.find_by(id: product.id).available).wont_equal true
      end
    end
  end 
  
  describe "guest users" do
    describe "update" do
      it "can not create a product" do
        product_hash = {
          product: {
            user_id: nil,
            name: "new product",
            description: "new description",
            price: 1.99,
            stock: 49,
            photo_url: "new_photo url"
          }
        }
        
        expect {
          post products_path, params: product_hash
        }.wont_change "Product.count"
      end
      
      it "can not update a product" do
        product = products(:orchid)
        product_hash = {
          product: {
            user_id: nil,
            name: "new product",
            description: "new description",
            price: 14,
            stock: 100,
            photo_url: "new_photo url"
          }
        }
        
        patch product_path(product.id), params: product_hash
        expect(flash[:error]).must_equal "A guest cannot update a product."
      end
    end
    
    describe "edit" do      
      it "cannot get the edit page for a product" do
        product = products(:treeivy)
        
        get edit_product_path(product.id)
        
        must_redirect_to product_path(product.id)
        expect(flash[:error]).must_equal "A guest cannot edit a product"
      end
    end
    
    describe "new" do      
      it "cannot get the new page for a product" do
        get new_product_path
        
        must_redirect_to products_path
        expect(flash[:error]).must_equal "A guest cannot create a product"
      end
    end
  end
end

