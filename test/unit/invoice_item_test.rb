require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  test 'required fields' do
    item = InvoiceItem.new
    item.unitary_cost = 3
    item.discount = 1
    item.quantity = 3
    assert !item.save
    item.description = 'test'
    assert item.save
  end

  test "numerical fields" do
    item = InvoiceItem.new
    item.description = 'test'
    item.unitary_cost = 3
    item.discount = 1
    item.quantity = 3
    assert item.save
    item.discount = 'abc'
    assert !item.save
    item.discount = 3
    item.quantity = 'abc'
    assert !item.save
    item.quantity = 2
    item.discount = 'abc'
    assert !item.save
   end
  test "basic calculations" do
    item = invoice_items(:three)
    assert_equal item.base_amount, 10
    assert_equal item.discount_amount, 0.4
    assert_equal item.net_amount, 9.6
  end
end
