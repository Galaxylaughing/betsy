require "test_helper"

describe Product do
  describe "validations" do 
    before do
      @user = User.create(username: "test user", email: "test email")
      @product = Product.create(user_id: @user.id, name: "test product", description: "cool product", price: 1.9, photo_url: "url", stock: 3)
    end
    
    it "is valid when all fields are present" do
      result = @product.valid?
      expect(result).must_equal true
    end
    
    it "is invalid without a name" do 
      @product.name = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid if name is not unique" do
      @product.name = products(:orquid).name
      expect(@product.valid?).must_equal false
      expect(@product.errors.messages).must_include :name
    end
    
    it "is invalid without a description" do
      @product.description = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without a price" do
      @product.price = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid if price is not a number" do
      @product.price = "nine"
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid if price is not greater than 0" do
      @product.price = 0
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid wihout a photo url" do
      @product.photo_url = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without stock quantity" do 
      @product.stock= nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without if stock quantity is not a number" do 
      @product.stock = "eleven"
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without availability status" do 
      @product.available = nil
      result = @product.valid?
      expect(result).must_equal false
    end
    
    it "is invalid without a user id" do 
      @product.user_id = nil
      result = @product.valid?
      expect(result).must_equal false
    end
  end
end
