require "test_helper"

describe Order do
  let (:new_order) {
    Order.new(email: "geob@gmail.com", address: "bellevue", name: "georgina", cc_num: "1111111111111111", cvv_code: "111", zip: "98003")
  }
  describe 'validations' do
    it 'is valid when all fields are present' do
      expect(orders(:georgina_order).valid?).must_equal true
    end

    it "will have the required fields" do
      new_order.save
      order = Order.first
      [:email, :address, :name, :cc_num, :cvv_code, :zip].each do |field|
        expect(order).must_respond_to field
      end
    end 
  
    it "is not valid without an email" do
      invalid_order = Order.new(name: "georgina", address: "bellevue", cc_num: "1111111111111111", cvv_code: "111", zip: "98003")
      expect(invalid_order.valid?).must_equal false
      expect(invalid_order.errors.messages).must_include :email
    end

    it "is not valid without an address" do
      invalid_order = Order.new(email: "geob@gmail.com", name: "georgina", cc_num: "1111111111111111", cvv_code: "111", zip: "98003")
      expect(invalid_order.valid?).must_equal false
      expect(invalid_order.errors.messages).must_include :address
    end

    it "is not valid without an cc_num" do
      invalid_order = Order.new(email: "geob@gmail.com", name: "georgina", address: "bellevue", cvv_code: "111", zip: "98003")
      expect(invalid_order.valid?).must_equal false
      expect(invalid_order.errors.messages).must_include :cc_num
    end

    it "is not valid without an cvv_code" do
      invalid_order = Order.new(email: "geob@gmail.com", name: "georgina", cc_num: "1111111111111111", address: "bellevue", zip: "98003")
      expect(invalid_order.valid?).must_equal false
      expect(invalid_order.errors.messages).must_include :cvv_code
    end

    it "is not valid without an zip" do
      invalid_order = Order.new(email: "geob@gmail.com", name: "georgina", address: "bellevue", cvv_code: "111", cc_num: "1111111111111111")
      expect(invalid_order.valid?).must_equal false
      expect(invalid_order.errors.messages).must_include :zip
    end
  end

  describe "relationships" do
    it "has many order_items" do
      # Arrange
      new_order.save
      user = User.create(username: "georgina", email: "geor@gmail.com")
      product_cactus = Product.create(user_id: user.id, name: "cactus", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
      product_flower = Product.create(user_id: user.id, name: "flower", description: "cool flower", price: 1.5, photo_url: "url", stock: 3)
      order_items_1 = OrderItem.create(product_id: product_cactus.id, order_id: new_order.id, quantity: 3)
      order_items_2 = OrderItem.create(product_id: product_flower.id, order_id: new_order.id, quantity: 1)
      

      expect(new_order.order_items.count).must_be :>, 0
      new_order.order_items.each do |order|
        expect(order).must_be_instance_of OrderItem
      end
    end
  end
end
