require "test_helper"

describe OrderItemsController do
  describe 'relations' do
    it 'an orderitem belongs to a product' do
      begonia = products(:begonia)
      begonia_id = products(:begonia).id
      order_id = orders(:myrta_order).id
      
      order_item = OrderItem.create(quantity: 1, product_id: begonia_id, order_id: order_id)
      
      expect(order_item.product_id).must_equal begonia_id
    end
    
    it 'an orderitem belongs to an order' do
      begonia = products(:begonia)
      begonia_id = products(:begonia).id
      order_id = orders(:myrta_order).id
      
      order_item = OrderItem.create(quantity: 1, product_id: begonia_id, order_id: order_id)
      
      expect(order_item.order_id).must_equal order_id
    end
  end
end