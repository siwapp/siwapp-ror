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
    assert_equal invoice.tax_amount, 2.53427958
    assert_equal invoice.gross_amount, 39.33825858
    assert_equal invoice.paid_amount, 20.34
    assert_equal invoice.due_amount, 18.99825858
  end
end
