require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test "required fields and numerical amount" do
    payment = Payment.new
    payment.amount = '33.3'
    assert !payment.save
    payment.date = '2012-8-8'
    assert payment.save
    payment.amount = 'amount'
    assert !payment.save
  end
  # test "the truth" do
  #   assert true
  # end
end
