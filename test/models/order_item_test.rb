require "test_helper"

describe OrderItem do
  describe 'relations' do
    before do
      @product = products(:begonia)
      @order = orders(:myrta_order)
      @order_item = OrderItem.new(quantity: 1, product_id: @product.id, order_id: @order.id)
    end
    
    it 'an order_item belongs to a product' do
      expect(@order_item.product_id).must_equal @product.id
    end
    
    it 'an order_item belongs to an order' do
      expect(@order_item.order_id).must_equal @order.id
    end
  end
end
