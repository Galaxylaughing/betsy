require "test_helper"

describe UsersHelper do
  include UsersHelper
  
  describe 'mask_cc' do
    let(:cc_num) {
      "123456789123456789"
    }
    let(:masked) {
      mask_cc(cc_num)
    }
    
    it "returns a string of the same length" do
      expect(masked.length).must_equal cc_num.length
    end
    
    it "turns all chars except the last four into asterisks" do
      expect(masked).must_equal "**************6789"
    end
  end
end