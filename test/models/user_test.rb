require "test_helper"

describe User do
  describe "relationships" do
    let(:merchant) {
      User.create(username: "Begonia", email: "b_begonia@example.com")
    }
    let(:photo_url) {
      "https://example_photo.com"
    }
    
    it "can have a single product" do
      merchant_id = merchant.id
      description = "a small fern"
      
      small_fern = Product.create(name: "small fern", description: description, price: 5.25, stock: 3, user_id: merchant_id, photo_url: photo_url)
      saved_product = Product.find_by(description: description)
      
      expect(merchant.products).must_include saved_product
    end
    
    it "can have multiple products" do
      merchant_id = merchant.id
      fern_description = "a small fern"
      cactus_description = "a large cactus"
      
      small_fern = Product.create(name: "small fern", description: fern_description, price: 5.25, stock: 3, user_id: merchant_id, photo_url: photo_url)
      large_cactus = Product.create(name: "large cactus", description: cactus_description, price: 5.25, stock: 3, user_id: merchant_id, photo_url: photo_url)
      
      saved_fern = Product.find_by(description: fern_description)
      saved_cactus = Product.find_by(description: cactus_description)
      
      expect(merchant.products).must_include saved_fern
      expect(merchant.products).must_include saved_cactus
    end
  end
  
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
      expect(merchant.errors.messages).must_include :username
    end
    
    it "is not valid without an email" do
      merchant = User.new(username: username)
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :email
    end
    
    it "is not valid without a unique username" do
      merchant.save!
      
      new_merchant = User.new(username: username, email: "o_orchid@example.com")
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :username
    end
    
    it "is not valid without a unique email" do
      merchant.save!
      
      new_merchant = User.new(username: "Orchid", email: email)
      
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
    end
    
    describe "email validations" do
      # email validation cases from https://en.wikipedia.org/wiki/Email_address
      
      it "is valid with a hyphen" do
        email = "local-part@domain.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a period" do
        email = "very.common@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with periods and a plus sign" do
        email = "disposable.style.email.with+symbol@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a period and hyphens" do
        email = "other.email-with-hyphen@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a single character" do
        email = "x@example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a hyphen in domain" do
        email = "example-indeed@strange-example.com"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a period in domain" do
        email = "example@s.example"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a bang" do
        email = "mailhost!username@example.org"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is valid with a percent" do
        email = "user%example.com@example.org"
        merchant = User.new(username: username, email: email)
        
        expect(merchant.valid?).must_equal true
      end
      
      it "is invalid without an @ sign" do
        invalid = "Abc.example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it has multiple @ signs" do
        invalid = "A@b@c@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it has special characters" do
        invalid = "a\"b(c)d,e:f;g<h>i[j\k]l@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it contains quoted strings" do
        invalid = "just\"not\"right@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
      
      it "is invalid if it contains special characters" do
        invalid = "this\ still\"not\\allowed@example.com"
        merchant = User.new(username: username, email: invalid)
        
        expect(merchant.valid?).must_equal false
        expect(merchant.errors.messages).must_include :email
      end
    end
  end
  
  describe "list" do
    let(:list) {
      User.list
    }
    it "returns a list of all users" do
      expect(list.length).must_equal User.count
      
      list.each do |item|
        expect(item).must_be_instance_of User
      end
    end
    
    it "returns an alphabetized list" do
      # relies on "awesome_orchid" being 
      # the alphabetical first name in test database
      first_name = users(:orchid)
      
      expect(list.first).must_equal first_name
    end
  end
end
