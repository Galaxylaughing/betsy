require "test_helper"

describe Category do
  describe 'relations' do
    let(:full_sun) { categories(:full_sun)}
    let(:shade) { categories(:shade) }
    let(:begonia) { products(:begonia) }
    let(:orchid) { products(:orchid) }
    
    it 'can have many products' do
      full_sun.products << begonia
      full_sun.products << orchid
      
      expect(full_sun.products.count).must_equal 2
    end
    
    it 'can belong to many products' do
      full_sun.products << begonia
      full_sun.products << orchid
      
      assert_not_nil(begonia.categories)
      assert_not_nil(orchid.categories)
    end
  end
  
  describe 'validations' do
    let(:full_sun) { categories(:full_sun) }
    
    it 'is valid when name is present' do
      expect(full_sun.valid?).must_equal true
    end
    
    it 'is invalid without a name' do
      full_sun.name = nil
      
      expect(full_sun.valid?).must_equal false
    end
    
    it 'is valid when the name is unique' do
      expect(categories(:full_sun).valid?).must_equal true
    end
    
    it 'is invalid when the name is not unique' do
      existing_category = categories(:full_sun)
      new_category = Category.create(name: "Full Sun")
      
      expect(new_category.valid?).must_equal false
      expect(new_category.errors.messages).must_include :name
    end
  end
end
