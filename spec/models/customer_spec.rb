require 'rails_helper'

RSpec.describe Customer, :type => :model do

  def build_invoice(**kwargs)
    invoice = Invoice.new(
      name: "A Customer",
      issue_date: Date.current,
      **kwargs
    )
    invoice.set_amounts
    invoice
  end

  it "is not valid without a name or identification" do
    c = Customer.new
    expect(c).not_to be_valid
    expect(c.errors.messages.has_key? :base).to be true
  end

  it "is valid with a name" do
    expect(Customer.new(name: 'A Customer')).to be_valid
  end

  it "is valid with an identification" do
    expect(Customer.new(identification: '123456789Z')).to be_valid
  end

  it "discard drafts and failed invoices when calculating totals" do
    customer = Customer.create(name: 'A Customer')
    series = Series.create(value: "A")

    customer.invoices << build_invoice(series: series,
                                       items: [Item.new(quantity: 1, unitary_cost: 10)],
                                       payments: [Payment.new(amount: 5, date: Date.current)])
    customer.invoices << build_invoice(series: series,
                                       items: [Item.new(quantity: 1, unitary_cost: 20)],
                                       payments: [Payment.new(amount: 10, date: Date.current)],
                                       draft: true)
    customer.invoices << build_invoice(series: series,
                                       items: [Item.new(quantity: 1, unitary_cost: 20)],
                                       payments: [Payment.new(amount: 10, date: Date.current)],
                                       failed: true)
    customer.save

    expect(customer.total).to eq 10
    expect(customer.paid).to eq 5
    expect(customer.due).to eq 5
  end

  it "is not deleted if there are pending invoices" do
    customer = Customer.new(name: 'A Customer')
    customer.invoices << build_invoice(series: Series.new(value: "A"),
                                       items: [Item.new(quantity: 1, unitary_cost: 10)])
    customer.save
    expect(customer.destroy).to be false
    expect(customer.errors[:base][0]).to include "can't be deleted"
  end

  it "is deleted, draft or failed invoices don't prevent deletion" do
    series = Series.new(value: "A")
    customer = Customer.new(name: 'A Customer')
    customer.invoices << build_invoice(series: series,
                                       items: [Item.new(quantity: 1, unitary_cost: 10)],
                                       failed: true)
    customer.invoices << build_invoice(series: series,
                                       items: [Item.new(quantity: 1, unitary_cost: 10)],
                                       draft: true)
    customer.save

    expect(customer.destroy).not_to be false
    expect(customer.deleted?).to be true
  end

end
