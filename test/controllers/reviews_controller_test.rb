require "test_helper"

describe ReviewsController do
  describe "logged in user" do
    describe "create" do
      before do
        user = users(:orchid)
        perform_login(user)
      end
      
      it "lets a logged in user review another user's product" do
        params_hash = {
          review: {
            rating: 5,
            comment: "great plant"
          }
        }
        
        # treeivy is not orchid's product
        product = products(:treeivy)
        
        expect {
          post product_reviews_path(product.id), params: params_hash
        }.must_differ "Review.count", 1
        
        new_review = Review.last
        expect(new_review.comment).must_equal params_hash[:review][:comment]
        expect(new_review.rating).must_equal params_hash[:review][:rating]
      end
      
      it "does not let a logged in user review their own product" do
        params_hash = {
          review: {
            rating: 5,
            comment: "great plant"
          }
        }
        
        # hollyhock is one of orchid's products
        product = products(:hollyhock)
        
        expect {
          post product_reviews_path(product.id), params: params_hash
        }.wont_change "Review.count"
        
        must_redirect_to product_path(product.id)
        expect(flash[:error]).must_equal "You cannot review your own product"
      end
    end
  end
end
