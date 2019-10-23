require "test_helper"

describe User do
  describe "validations" do
    let(:username) {
      "Begonia"
    }
    
    let(:email) {
      "b_begonia@example.com"
    }
    
    let(:merchant) {
      User.new(username: username, email: email)
    }
    
    it "is valid with a username and email" do
      expect(merchant.valid?).must_equal true
    end
    
    it "can be created with a username and email" do
      merchant.save!
      saved_merchant = User.find_by(username: username)
      
      expect(saved_merchant).wont_be_nil
      expect(saved_merchant.username).must_equal username
      expect(saved_merchant.email).must_equal email
    end
    
    it "is not valid without a username" do
      merchant = User.new(email: email)
      expect(merchant.valid?).must_equal false
      merchant.errors.messages.must_include :username
    end
    
    it "is not valid without an email" do
      merchant = User.new(username: username)
      expect(merchant.valid?).must_equal false
      merchant.errors.messages.must_include :email
    end
    
    it "is not valid without a unique username" do
      merchant.save!
      
      new_merchant = User.new(username: username, email: "o_orchid@example.com")
      
      expect(new_merchant.valid?).must_equal false
      new_merchant.errors.messages.must_include :username
    end
    
    it "is not valid without a unique email" do
      merchant.save!
      
      new_merchant = User.new(username: "Orchid", email: email)
      
      expect(new_merchant.valid?).must_equal false
      new_merchant.errors.messages.must_include :email
    end
  end
end
