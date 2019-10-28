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
  end
end