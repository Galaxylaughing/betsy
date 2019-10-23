require "test_helper"

describe Order do
  describe 'validations' do
    it 'is valid when all fields are present' do
      expect(orders(:georgina_order).valid?).must_equal true
    end
  end
end
