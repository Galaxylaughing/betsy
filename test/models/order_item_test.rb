require "test_helper"

describe OrderItem do
  describe 'relations' do
    before do
      @product = products(:begonia)
      @order = 
      @order_item = OrderItem.new(quantity: 1, product_id: @product.id, order_id: @order.id)
    end
    it 'an order_item belongs to a product' do
      order_item = order_item(:hal_book)
      expect(vote.work_id).must_equal works(:green).id
    end
    
    it 'an order_item belongs to an order' do
      vote = votes(:hal_book)
      expect(vote.user_id).must_equal users(:hallie).id
    end
  end
end
