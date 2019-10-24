require "test_helper"

describe OrderItemsController do
  describe 'relations' do
    it 'an orderitem belongs to a product' do
      order_item = product(:)
      expect(order_item.product_id).must_equal products(:begonia).id
    end
    
    it 'an orderitem belongs to an order' do
      vote = votes(:hal_book)
      expect(vote.user_id).must_equal users(:hallie).id
    end
  end
  