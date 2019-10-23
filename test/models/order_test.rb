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
end
