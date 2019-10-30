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
  
  describe "total_revenue_by_order" do
    it "calculates the user's total revenue for a given order" do
      # orchid has two orders
      user = users(:orchid)
      
      order_1_id = orders(:ducky_orchid_bellflower).id
      order_2_id = orders(:bear_orchid_hollyhock).id
      
      # ducky_bellflower:
      #   quantity: 1
      #   product: bellflower
      #   status: paid
      #   => total: 12.75
      # bear_hollyhock:
      #   quantity: 2
      #   product: hollyhock
      #   status: complete
      #   => total: 25.5
      
      result_1 = user.total_revenue_by_order(order_1_id)
      expect(result_1).must_equal 12.75
      
      result_2 = user.total_revenue_by_order(order_2_id)
      expect(result_2).must_equal 25.5
    end
  end
  
  describe "total revenue" do
    it "calculates the user's total revenue" do
      # orchid has two orders
      user = users(:orchid)
      
      # hollyhock:
      #   price: 12.75
      # bellflower:
      #   price: 12.75
      
      # ducky_bellflower:
      #   quantity: 1
      #   product: bellflower
      #   status: paid
      #   => total: 12.75
      # bear_hollyhock:
      #   quantity: 2
      #   product: hollyhock
      #   status: complete
      #   => total: 25.5
      
      result = user.total_revenue()
      
      expect(result).must_equal 38.25
    end
    
    it "returns zero if there are no orders" do
      # rose has one product with no orders
      user = users(:rose)
      
      result = user.total_revenue()
      
      expect(result).must_equal 0.00
    end
    
    it "returns zero if there are no products" do
      # petunia has no products
      user = users(:petunia)
      
      result = user.total_revenue()
      
      expect(result).must_equal 0.00
    end
  end
  
  describe "total revenue by status" do
    it "calculates the user's total revenue for their orders per status" do
      # orchid has two orders
      user = users(:orchid)
      
      # hollyhock:
      #   price: 12.75
      # bellflower:
      #   price: 12.75
      
      # ducky_bellflower:
      #   quantity: 1
      #   product: bellflower
      #   status: paid
      #   => total: 12.75
      # bear_hollyhock:
      #   quantity: 2
      #   product: hollyhock
      #   status: complete
      #   => total: 25.5
      
      complete_result = user.total_revenue_by_status(:complete)
      expect(complete_result).must_equal 25.5
      
      paid_result = user.total_revenue_by_status(:paid)
      expect(paid_result).must_equal 12.75
    end
    
    it "calculates the user's total revenue for their orders per status" do
      # crabapple has one order with two order_items
      user = users(:crabapple)
      
      # one order_item is complete
      # one is only paid
      
      # the order is not complete, so no order_item,
      # regardless of its individual status,
      # should count toward this total
      complete_result = user.total_revenue_by_status(:complete)
      expect(complete_result).must_equal 0.00
      
      # the order is paid, so each order_item,
      # regardless of its individual status,
      # should count toward this total
      paid_result = user.total_revenue_by_status(:paid)
      expect(paid_result).must_equal 35.00
    end
    
    it "returns 0.00 for any nonexistent statuses" do
      # crabapple has one order with two order_items
      user = users(:crabapple)
      
      # one order_item is complete
      # one is only paid
      
      complete_result = user.total_revenue_by_status(:pending)
      expect(complete_result).must_equal 0.00
      
      complete_result = user.total_revenue_by_status(:cancelled)
      expect(complete_result).must_equal 0.00
    end
  end
  
  describe "sort orders by status" do
    # if a user has no orders
    it "returns empty if there are no orders" do
      # rose has one product with no orders
      user = users(:rose)
      
      response = user.sort_orders_by_status()
      
      expect(response).wont_be_nil
      expect(response.empty?).must_equal true
    end
    
    # if a user has no products
    it "returns empty if there are no products" do
      # petunia has no products
      user = users(:petunia)
      
      response = user.sort_orders_by_status()
      
      expect(response).wont_be_nil
      expect(response.empty?).must_equal true
    end
    
    # if a user has one order, all their order_items, and they are all paid (order should be paid)
    #   => {paid: [order]}, guava_shop_order
    it "is paid if all the order items are paid" do
      user = users(:guava)
      response = user.sort_orders_by_status()
      
      expect(response[:paid]).wont_be_nil
      expect(response[:paid]).must_include orders(:guava_shop_order)
    end
    
    # if a user has one order, all their order_items, and they are all complete but one is paid (order should be paid)
    #   => {paid: [order]}, pineapple_shop_order
    # WRONG, pending
    it "is paid if one order item is complete and one is paid" do
      user = users(:pineapple)
      response = user.sort_orders_by_status()
      
      expect(response[:paid]).wont_be_nil
      expect(response[:paid]).must_include orders(:pineapple_shop_order)
    end
    
    # if a user has one order, all their order_items, and they are all complete but one is cancelled (order should be complete)
    #   => {complete: [order]}, orange_shop_order
    # WRONG, pending
    it "is complete if one order item is complete and one is cancelled" do
      user = users(:orange)
      response = user.sort_orders_by_status()
      
      expect(response[:complete]).wont_be_nil
      expect(response[:complete]).must_include orders(:orange_shop_order)
    end
    
    # if a user has one order, all their order_items, and they are all complete (order should be complete)
    #   => {complete: [order]}, plum_shop_order
    it "is complete if all the order items are complete" do
      user = users(:plum)
      response = user.sort_orders_by_status()
      
      expect(response[:complete]).wont_be_nil
      expect(response[:complete]).must_include orders(:plum_shop_order)
    end
    
    # if a user has one order, half their order_items, and they are all paid & other half is complete (order should be paid)
    #   => {paid: [order]}, peach_shop_order
    it "is paid if all this users's order items are paid" do
      user = users(:peach)
      response = user.sort_orders_by_status()
      
      expect(response[:paid]).wont_be_nil
      expect(response[:paid]).must_include orders(:peach_shop_order)
    end
    
    # if a user has one order, half their order_items, and they are all complete but one is paid & other half is paid (order should be paid)
    #   => {paid: [order]}, carrot_shop_order
    # WRONG, pending
    it "is paid if one of this users's order items is complete and one is paid" do
      user = users(:carrot)
      response = user.sort_orders_by_status()
      
      expect(response[:paid]).wont_be_nil
      expect(response[:paid]).must_include orders(:carrot_shop_order)
    end
    
    # if a user has one order, half their order_items, and they are all complete but one is cancelled & other half is paid (order should be complete)
    #   => {complete: [order]}, berry_shop_order
    # WRONG, pending
    it "is paid if one of this users's order items is complete and one is cancelled" do
      user = users(:berry)
      response = user.sort_orders_by_status()
      
      expect(response[:complete]).wont_be_nil
      expect(response[:complete]).must_include orders(:berry_shop_order)
    end
    
    # if a user has one order, half their order_items, and they are all complete & other half is paid (order should be complete)
    #   => {complete: [order]}, melon_shop_order
    it "is paid if all this users's order items are complete" do
      user = users(:melon)
      response = user.sort_orders_by_status()
      
      expect(response[:complete]).wont_be_nil
      expect(response[:complete]).must_include orders(:melon_shop_order)
    end
    
    # if a user has one order, half their order_items, and they are all cancelled & other half is paid (order should be cancelled)
    #   => {cancelled: [order]}, grapefruit_shop_order
    it "is cancelled if all this users's order items are cancelled" do
      user = users(:grapefruit)
      response = user.sort_orders_by_status()
      
      expect(response[:cancelled]).wont_be_nil
      expect(response[:cancelled]).must_include orders(:grapefruit_shop_order)
    end
    
    # if a user has one order, half their order_items, and they are all pending & other half is paid (order should be pending)
    #   => {pending: [order]}, apricot_shop_order
    it "is pending if all this users's order items are pending" do
      user = users(:apricot)
      response = user.sort_orders_by_status()
      
      expect(response[:pending]).wont_be_nil
      expect(response[:pending]).must_include orders(:apricot_shop_order)
    end
  end
  
  describe "get order status" do  
    # if a user has one order, all their order_items, and they are all paid (order should be paid)
    #   => {paid: [order]}, guava_shop_order
    it "is paid if all the order items are paid" do
      user = users(:guava)
      response = user.get_order_status(orders(:guava_shop_order))
      
      expect(response).must_equal :paid
    end
    
    # if a user has one order, all their order_items, and they are all complete but one is paid (order should be paid)
    #   => {paid: [order]}, pineapple_shop_order
    it "is paid if one order item is complete and one is paid" do
      user = users(:pineapple)
      response = user.get_order_status(orders(:pineapple_shop_order))
      
      expect(response).must_equal :paid
    end
    
    # if a user has one order, all their order_items, and they are all complete but one is cancelled (order should be complete)
    #   => {complete: [order]}, orange_shop_order
    it "is complete if one order item is complete and one is cancelled" do
      user = users(:orange)
      response = user.get_order_status(orders(:orange_shop_order))
      
      expect(response).must_equal :complete
    end
    
    # if a user has one order, all their order_items, and they are all complete (order should be complete)
    #   => {complete: [order]}, plum_shop_order
    it "is complete if all the order items are complete" do
      user = users(:plum)
      response = user.get_order_status(orders(:plum_shop_order))
      
      expect(response).must_equal :complete
    end
    
    # if a user has one order, half their order_items, and they are all paid & other half is complete (order should be paid)
    #   => {paid: [order]}, peach_shop_order
    it "is paid if all this users's order items are paid" do
      user = users(:peach)
      response = user.get_order_status(orders(:peach_shop_order))
      
      expect(response).must_equal :paid
    end
    
    # if a user has one order, half their order_items, and they are all complete but one is paid & other half is paid (order should be paid)
    #   => {paid: [order]}, carrot_shop_order
    it "is paid if one of this users's order items is complete and one is paid" do
      user = users(:carrot)
      response = user.get_order_status(orders(:carrot_shop_order))
      
      expect(response).must_equal :paid
    end
    
    # if a user has one order, half their order_items, and they are all complete but one is cancelled & other half is paid (order should be complete)
    #   => {complete: [order]}, berry_shop_order
    it "is paid if one of this users's order items is complete and one is cancelled" do
      user = users(:berry)
      response = user.get_order_status(orders(:berry_shop_order))
      
      expect(response).must_equal :complete
    end
    
    # if a user has one order, half their order_items, and they are all complete & other half is paid (order should be complete)
    #   => {complete: [order]}, melon_shop_order
    it "is paid if all this users's order items are complete" do
      user = users(:melon)
      response = user.get_order_status(orders(:melon_shop_order))
      
      expect(response).must_equal :complete
    end
    
    # if a user has one order, half their order_items, and they are all cancelled & other half is paid (order should be cancelled)
    #   => {cancelled: [order]}, grapefruit_shop_order
    it "is cancelled if all this users's order items are cancelled" do
      user = users(:grapefruit)
      response = user.get_order_status(orders(:grapefruit_shop_order))
      
      expect(response).must_equal :cancelled
    end
    
    # if a user has one order, half their order_items, and they are all pending & other half is paid (order should be pending)
    #   => {pending: [order]}, apricot_shop_order
    it "is pending if all this users's order items are pending" do
      user = users(:apricot)
      response = user.get_order_status(orders(:apricot_shop_order))
      
      expect(response).must_equal :pending
    end
  end
  
  describe "find orders by status" do
    let(:user) {
      users(:mango)
    }
    
    # if a user has six orders,
    # and two are complete, one is cancelled, two are paid, one is pending,
    # they should be able to see a list of all of them
    it "returns any complete orders" do
      response = user.find_orders_by_status(:complete)
      
      expect(response).wont_be_nil
      expect(response.length).must_equal 2
      expect(response).must_include orders(:mango_shop_complete_1)
      expect(response).must_include orders(:mango_shop_complete_2)
    end
    
    it "returns any cancelled orders" do
      response = user.find_orders_by_status(:cancelled)
      
      expect(response).wont_be_nil
      expect(response.length).must_equal 1
      expect(response).must_include orders(:mango_shop_cancelled)
    end
    
    it "returns any paid orders" do
      response = user.find_orders_by_status(:paid)
      
      expect(response).wont_be_nil
      expect(response.length).must_equal 2
      expect(response).must_include orders(:mango_shop_paid_1)
      expect(response).must_include orders(:mango_shop_paid_2)
    end
    
    it "returns any pending orders" do
      response = user.find_orders_by_status(:pending)
      
      expect(response).wont_be_nil
      expect(response.length).must_equal 1
      expect(response).must_include orders(:mango_shop_pending)
    end
    
    it "returns all orders if you pass in all" do
      response = user.find_orders_by_status(:all)
      
      expect(response).wont_be_nil
      expect(response.length).must_equal 6
      expect(response).must_include orders(:mango_shop_complete_1)
      expect(response).must_include orders(:mango_shop_complete_2)
      expect(response).must_include orders(:mango_shop_cancelled)
      expect(response).must_include orders(:mango_shop_paid_1)
      expect(response).must_include orders(:mango_shop_paid_2)
      expect(response).must_include orders(:mango_shop_pending)
    end
    
  end
  
end
