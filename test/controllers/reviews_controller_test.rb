
require "test_helper"

describe ReviewsController do
  describe 'guest users' do
    describe "index" do
      it "gives back a susccesful response" do
        get orders_path
        must_respond_with :success
      end
      
      it "can get the root path" do
        get root_path
        must_respond_with :success
      end
    end

    describe "create" do
      it 'creates a review successfully while not logged in' do
        product = products(:hollyhock)
        review_hash = {
          review: {
            comment: "beautiful",
            rating: 3,
          }
        }

        expect {
          post "/products/#{product.id}/reviews", params: review_hash
        }.must_differ 'Review.count', 1
      end
    end
  end

  describe "Logged in users" do
    before do
      perform_login(users(:begonia))
    end

    describe "index" do
      it "gives back a susccesful response" do
        get orders_path
        must_respond_with :success
      end
      
      it "can get the root path" do
        get root_path
        must_respond_with :success
      end
    end

    describe "create" do
      it 'creates a review successfully while logged in' do
        product = products(:hollyhock)
        review_hash = {
          review: {
            comment: "beautiful",
            rating: 3,
          }
        }

        expect {
          post "/products/#{product.id}/reviews", params: review_hash
        }.must_differ 'Review.count', 1
      end
    end

  end
end
