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
  end
end
