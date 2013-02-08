require 'test_helper'

class TaxTest < ActiveSupport::TestCase
  test "required fields" do
    tax = Tax.new
    assert !tax.save
    tax = taxes(:one)
    tax.name = nil
    assert !tax.save
  end

  test "numerical fields" do
    tax = taxes(:one) 
    tax.value = 'xx'
    assert !tax.save
  end 

  test "boolean fields" do
    tax = taxes(:one) 
    tax.is_default = nil
    assert !tax.save
  end

end
