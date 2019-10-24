require "test_helper"

describe 'Category' do
  describe 'relations' do
    let(:annual) { Category.create!(name: "annual") }
    let(:flower) { Category.create!(name: "flower") }
    let(:begonia) { products(:begonia) }
    let(:orchid) { products(:orchid) }
    
    it 'can have many products' do
      annual.products << begonia
      annual.products << orchid
      
      expect(annual.products.count).must_equal 2
    end
    
    it 'can belong to many products' do
      annual.products << begonia
      annual.products << orchid
      
      expect(begonia.category).must_equal annual
      expect(orchid.category).must_equal annual
    end
  end
end
