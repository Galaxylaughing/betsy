require "test_helper"

describe Review do
  before do
    @product = products(:begonia)
    @review = Review.create!(rating: 4, comment: "I love the pretty flowers!", product_id: @product.id)
  end
  
  describe 'relations' do
    it 'belongs to a product' do
      expect(@review.product_id).must_equal @product.id
    end
  end
  
  describe 'validations' do
    before do
      before do
        let(:product) { products(:begonia) }
        let(:review) { Review.create!(rating: 4, comment: "I love the pretty flowers!", product_id: @product.id) }
      end
      
      it 'is valid when there is a rating between 1 and 5 entered' do
        expect(review.valid?).must_equal true
        
        review.rating = 1
        expect(review.valid?).must_equal true
        
        review.rating = 5
        expect(review.valid?).must_equal true
      end
      
      it 'is not valid with a rating that is not between 1 and 5' do
        
      end
    end
  end
end
