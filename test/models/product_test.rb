require "test_helper"

describe Product do
  describe "validations" do 
    before do
      @user = User.create(username: "test user", email: "test_email@example.com")
      @product = Product.create(user_id: @user.id, name: "test product", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
    end
    
    it "is valid when all fields are present" do
      result = @product.valid?
      expect(result).must_equal true
    end
    
    it "is invalid without a name" do 
      @product.name = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid if name is not unique" do
      @product.name = products(:orchid).name
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages).must_include :name
    end
    
    it "is invalid without a description" do
      @product.description = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without a price" do
      @product.price = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid if price is not a number" do
      @product.price = "nine"
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid if price is not greater than 0" do
      @product.price = 0
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid wihout a photo url" do
      @product.photo_url = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without stock quantity" do 
      @product.stock= nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without if stock quantity is not a number" do 
      @product.stock = "eleven"
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without availability status" do 
      @product.available = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without a user id" do 
      @product.user_id = nil
      result = @product.valid?
      expect(result).must_equal false
    end
  end
  
  describe "relationships" do
    before do
      @user = User.create(username: "test user", email: "test_email@example.com") 
      @category1 = Category.create(name: "flower")
      @category2 = Category.create(name: "specialty")
      @product = Product.create(user_id: @user.id, name: "test product", description: "cool product", price: 1.9, photo_url: "url", stock: 3, categories: [@category1, @category2]) 
      
      @review1 = Review.create(product_id: @product.id, rating: 5, comment: "great product")
      @review2 = Review.create(product_id: @product.id, rating: 2, comment: "bad product")
      
      @order = Order.create(email: "test email", address: "test address", name: "test user name", cc_num: 1234, zip: 98111)
      
      @order_item1 = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity: 2)
      @order_item2 = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity: 4)
    end
    
    it "can have many reviews" do
      expect(@product.reviews.count).must_equal 2
    end
    
    it "can have many order items" do
      expect(@product.order_items.count).must_equal 2
    end
    
    it "can have many categories" do
      expect(@product.categories.count).must_equal 2
    end
    
    it "belongs to a user" do
      assert_not_nil(@product.user_id)
    end
  end
end
