require "test_helper"

describe User do
  describe "relationships" do
    let(:merchant) {
      User.create(username: "Begonia", email: "b_begonia@example.com")
    }
    let(:photo_url) {
      "https://example_photo.com"
    }
    
    it "can have a single product" do
      merchant_id = merchant.id
      description = "a small fern"
      
      small_fern = Product.create(name: "small fern", description: description, price: 5.25, stock: 3, user_id: merchant_id, photo_url: photo_url)
      saved_product = Product.find_by(description: description)
      
      expect(merchant.products).must_include saved_product
    end
    
    it "can have multiple products" do
      merchant_id = merchant.id
      fern_description = "a small fern"
      cactus_description = "a large cactus"
      
      small_fern = Product.create(name: "small fern", description: fern_description, price: 5.25, stock: 3, user_id: merchant_id, photo_url: photo_url)
      large_cactus = Product.create(name: "large cactus", description: cactus_description, price: 5.25, stock: 3, user_id: merchant_id, photo_url: photo_url)
      
      saved_fern = Product.find_by(description: fern_description)
      saved_cactus = Product.find_by(description: cactus_description)
      
      expect(merchant.products).must_include saved_fern
      expect(merchant.products).must_include saved_cactus
    end
  end
  
  describe "validations" do
    let(:username) {
      "Begonia"
    }
    
    let(:email) {
      "b_begonia@example.com"
    }
    
    let(:merchant) {
      User.new(username: username, email: email)
    }
    
    it "is valid with a username and email" do
      expect(merchant.valid?).must_equal true
    end
    
    it "can be created with a username and email" do
      merchant.save!
      saved_merchant = User.find_by(username: username)
      
      expect(saved_merchant).wont_be_nil
      expect(saved_merchant.username).must_equal username
      expect(saved_merchant.email).must_equal email
    end
    
    it "is not valid without a username" do
      merchant = User.new(email: email)
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end
    
    it "is not valid without an email" do
      merchant = User.new(username: username)
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
    end
    
    it "is not valid without a unique username" do
      merchant.save!
      
      new_merchant = User.new(username: username, email: "o_orchid@example.com")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :username
    end
    
    it "is not valid without a unique email" do
      merchant.save!
      
      new_merchant = User.new(username: "Orchid", email: email)
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
    end
    
    describe "email validations" do
      # email validation cases from https://en.wikipedia.org/wiki/Email_address
      
      it "is valid with a hyphen" do
        email = "local-part@domain.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a period" do
        email = "very.common@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with periods and a plus sign" do
        email = "disposable.style.email.with+symbol@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a period and hyphens" do
        email = "other.email-with-hyphen@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a single character" do
        email = "x@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a hyphen in domain" do
        email = "example-indeed@strange-example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a period in domain" do
        email = "example@s.example"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a bang" do
        email = "mailhost!username@example.org"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a percent" do
        email = "user%example.com@example.org"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is invalid without an @ sign" do
        invalid = "Abc.example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it has multiple @ signs" do
        invalid = "A@b@c@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it has special characters" do
        invalid = "a\"b(c)d,e:f;g<h>i[j\k]l@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it contains quoted strings" do
        invalid = "just\"not\"right@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it contains special characters" do
        invalid = "this\ still\"not\\allowed@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
    end
  end
  
  describe "list" do
    let(:list) {
      User.list
    }
    it "returns a list of all users" do
      expect(list.length).must_equal User.count
      
      list.each do |item|
        expect(item).must_be_instance_of User
      end
    end
    
    it "returns an alphabetized list" do
      # relies on "awesome_orchid" being 
      # the alphabetical first name in test database
      first_name = users(:orchid)
      
      expect(list.first).must_equal first_name
    end
  end
  
  describe "order count" do
    it "returns count of orders containing this user's product" do
      user = users(:orchid)
      # orchid has two products
      # for product 1, there is one order of one quantity
      # for product 2, there is one order of two quantity
      
      order_count = user.order_count
      
      expect(order_count).must_equal 2
    end
    
    it "returns zero if the user has no products" do
      user = users(:petunia)
      # petunia has no products
      
      order_count = user.order_count
      
      expect(order_count).must_equal 0
    end
    
    it "returns zero if there are no associated orders" do
      user = users(:rose)
      # rose has one product
      # it does not have any orders
      
      order_count = user.order_count
      
      expect(order_count).must_equal 0
    end
  end
  
  describe "find_orders" do
    it "returns a list of orders for a given merchant" do
      user = users(:orchid)
      
      # there are two orders that contain orchid's products
      
      # order's for orchid's products:
      #   ducky_orchid_bellflower
      #   bear_orchid_hollyhock
      
      # each has one of orchid's order-item:
      #   ducky_bellflower:
      #     quantity: 1
      #   bear_hollyhock:
      #     quantity: 2
      
      # one order also has one of begonia's products
      # bear_orchid_hollyhock
      #   bear_treeivy:
      #     quantity: 3
      
      orders = user.find_orders
      
      expect(orders).wont_be_nil
      expect(orders.length).must_equal 2
      
      first_order = orders.first
      expect(first_order.order_items).wont_be_nil
      # begonia's product should not be filtered out
      # the view will filter what the merchant should see
      expect(first_order.order_items.length).must_equal 2
      
      last_order = orders.last
      expect(last_order.order_items).wont_be_nil
      expect(last_order.order_items.length).must_equal 1
    end
    
    it "returns an empty list if there are no orders" do
      user = users(:rose)
      
      # rose has one product with no orders
      
      orders = user.find_orders
      
      expect(orders).wont_be_nil
      expect(orders.empty?).must_equal true
    end
    
    it "returns an empty list if there are no products" do
      user = users(:petunia)
      
      # petunia has no products
      
      orders = user.find_orders
      
      expect(orders).wont_be_nil
      expect(orders.empty?).must_equal true
    end
  end
  
  describe "top_product" do
    it "can find a users's top-selling product" do
      user = users(:orchid)
      # orchid has two orders
      # one with one bellflower
      # and one with two hollyhock
      top = products(:hollyhock)
      
      top_product = user.top_product
      
      expect(top_product).must_equal top
    end
    
    it "returns nil if the user has no products" do
      user = users(:petunia)
      # petunia has no products
      
      top_product = user.top_product
      
      expect(top_product).must_be_nil
    end
    
    it "returns nil if the user hasn't sold any products" do
      # rose has one product with no orders
      user = users(:rose)
      
      top_product = user.top_product
      
      expect(top_product).must_be_nil
    end
  end
  
end
