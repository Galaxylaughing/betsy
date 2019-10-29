require "test_helper"

describe Order do
  let (:order) {
    Order.create
  }
  let (:update_hash) { {
    name: "georgina", 
    address: "bellevue", 
    cc_num: "1111111111111111", 
    cvv_code: "111", 
    zip: "98003",
    email: "geo@fake.com"
  }
}

describe 'validations' do
  it 'is valid when all fields are present' do
    edit_order = order.update(update_hash)
    expect(edit_order).must_equal true
    
  end
  
  it "is not valid without an email" do
    invalid_order = order.update(name: "georgina", address: "bellevue", cc_num: "1111111111111111", cvv_code: "111", zip: "98003")
    expect(invalid_order).must_equal false
    # expect(invalid_order.errors.messages).must_include :email
  end
  
  it "is not valid without an address" do
    invalid_order = order.update(email: "geob@gmail.com", name: "georgina", cc_num: "1111111111111111", cvv_code: "111", zip: "98003")
    expect(invalid_order).must_equal false
    # expect(invalid_order.errors.messages).must_include :address
  end
  
  it "is not valid without an cc_num" do
    invalid_order = order.update(email: "geob@gmail.com", name: "georgina", address: "bellevue", cvv_code: "111", zip: "98003")
    expect(invalid_order).must_equal false
    # expect(invalid_order.errors.messages).must_include :cc_num
  end
  
  it "is not valid without an cvv_code" do
    invalid_order = order.update(email: "geob@gmail.com", name: "georgina", cc_num: "1111111111111111", address: "bellevue", zip: "98003")
    expect(invalid_order).must_equal false
    # expect(invalid_order.errors.messages).must_include :cvv_code
  end
  
  it "is not valid without an zip" do
    invalid_order = order.update(email: "geob@gmail.com", name: "georgina", address: "bellevue", cvv_code: "111", cc_num: "1111111111111111")
    expect(invalid_order).must_equal false
    # expect(invalid_order.errors.messages).must_include :zip
  end
end

describe "relationships" do
  it "has many order_items" do
    # Arrange
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

describe 'custom methods' do
  describe 'total' do
    let(:order) { orders(:bear_orchid_hollyhock)}
    
    it "calculates the correct total for an order" do
      expect(order.total).must_equal 63.75
    end
  end
end
end

