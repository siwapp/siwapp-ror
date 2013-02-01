require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  test "number is numeric" do
    invoice = Invoice.new
    invoice.number = 'abc'
    assert !invoice.save
  end
  test "basic calculations" do
    invoice = invoices(:one)
    assert_equal invoice.base_amount , 39.78
    assert_equal invoice.discount_amount, 2.976021
    assert_equal invoice.net_amount, 36.803979
  end
end
