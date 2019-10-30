require "test_helper"

describe ApplicationHelper do
  include ApplicationHelper
  
  describe 'render_date' do
    it "displays a date in a human-readable format" do
      date = Date.parse("october 20 2019")
      
      result = render_date(date)
      
      expect(result).must_equal "Oct 20, 2019"
    end
  end
  
  describe 'render_price' do
    it "displays a price with two digits after the decimal" do
      price = 57.599999999999994
      
      result = render_price(price)
      
      expect(result).must_equal "57.59"
    end
    
    it "displays 0.00 for 0" do
      price = 0
      
      result = render_price(price)
      
      expect(result).must_equal "0.00"
    end
  end
  
  describe "render_rating" do
    it "displays a rating of 5 as 5 filled stars" do
      rating = 5
      result = render_rating(rating)
      expect(result).must_equal '<i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>'
    end
    
    it "displays a rating of 3 as 3 filled stars and 2 empty" do
      rating = 3
      result = render_rating(rating)
      expect(result).must_equal '<i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i>'
    end
    
    it "displays a rating of 1 as 1 filled star and 4 empty" do
      rating = 1
      result = render_rating(rating)
      # assert_dom_equal(%{<i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i>}, result)
      expect(result).must_equal '<i class="fas fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i><i class="far fa-star"></i>'
    end
    
    it "returns 'no rating' if the rating is nil" do
      rating = nil
      result = render_rating(rating)
      expect(result).must_equal "no rating"
    end
  end
end

# test "should return the user's full name" do
#   user = users(:david)

#   assert_dom_equal %{<a href="/user/#{user.id}">David Heinemeier Hansson</a>}, link_to_user(user)
# end