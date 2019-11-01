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
      @user = User.create(username: "test user", email: "test-email@example.com") 
      @category1 = Category.create(name: "flower")
      @category2 = Category.create(name: "specialty")
      @product = Product.create(user_id: @user.id, name: "test product", description: "cool product", price: 1.9, photo_url: "url", stock: 3, categories: [@category1, @category2]) 
      
      @review1 = Review.create(product_id: @product.id, rating: 5, comment: "great product")
      @review2 = Review.create(product_id: @product.id, rating: 2, comment: "bad product")
      
      @order = Order.create(email: "testemail@example.com", address: "test address", name: "test user name", cc_num: 1234, zip: 98111, cvv_code: 123)
      
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
  
  describe "calculate average rating" do
    it "returns an integer average rating from reviews" do
      product = products(:bellflower)
      # has two reviews, with a rating of 1 and 5, respectively
      
      average = product.calculate_average_rating()
      
      expect(average).must_equal 3
    end
    
    it "wont return a float average rating" do
      product = products(:hollyhock)
      # has two reviews, with a rating of 4 and 5, respectively
      
      average = product.calculate_average_rating()
      
      # it should round down from 4.5 to 5
      expect(average).must_equal 4
    end
    
    it "returns nil if there are no reviews" do
      product = products(:treeivy)
      # there are no reviews on treeivy
      
      average = product.calculate_average_rating()
      
      expect(average).must_be_nil
    end
  end
  
  describe "sample_products_for_homepage" do
    it "can get a list of products from the database" do
      result = Product.sample_products_for_homepage()
      
      expect(result).wont_be_nil
      
      result.each do |item|
        expect(item).must_be_instance_of Product
      end
      
      expect(result.length).must_equal 5
    end
    
    it "won't return an unavailable product and won't return more than five" do
      all_yml_order_items = OrderItem.all
      all_yml_order_items.each do |oi|
        oi.delete()
      end
      
      all_yml_reviews = Review.all
      all_yml_reviews.each do |review|
        review.delete()
      end
      
      all_yml_products = Product.all
      all_yml_products.each do |product|
        product.delete()
      end
      
      user = users(:cherry)
      
      available_product_1 = Product.create(name: "plant 1", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: true, user_id: user.id)
      available_product_2 = Product.create(name: "plant 2", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: true, user_id: user.id)
      available_product_3 = Product.create(name: "plant 3", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: true, user_id: user.id)
      unavailable_product = Product.create(name: "plant unavailable", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: false, user_id: user.id)
      
      sample_list = Product.sample_products_for_homepage()
      
      expect(sample_list).wont_include unavailable_product
      expect(sample_list).must_include available_product_1
      expect(sample_list).must_include available_product_2
      expect(sample_list).must_include available_product_3
      
      available_product_4 = Product.create(name: "plant 4", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: true, user_id: user.id)
      available_product_5 = Product.create(name: "plant 5", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: true, user_id: user.id)
      available_product_6 = Product.create(name: "plant 6", description: "a cool plant", price: 12.00, photo_url: "https://lorempixel.com/300/300", stock: 5, available: true, user_id: user.id)
      
      sample_list = Product.sample_products_for_homepage()
      expect(sample_list.length).must_equal 5
    end
  end
  
  describe "count_sold" do
    it "will return an integer of items sold" do
      product = products(:snakeplant)
      # snakeplant has one complete order
      
      count = product.count_sold()
      
      expect(count).must_equal 8
    end
    
    it "will only count paid and completed orders" do
      product = products(:aloe)
      # aloe has four orders,
      # one paid, one completed, one cancelled, and one pending
      # paid and complete have a quantity of 2 and 2
      # cancelled and pending have a quantity of 3 and 3
      
      count = product.count_sold()
      
      expect(count).must_equal 4
    end
    
    it "will return zero if there are none sold" do
      product = products(:knautia)
      
      count = product.count_sold()
      
      expect(count).must_equal 0
    end
  end
end
