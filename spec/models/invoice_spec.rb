require 'rails_helper'

RSpec.describe Invoice, :type => :model do

  def build_invoice(**kwargs)
    kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series
    kwargs[:issue_date] = Date.current() unless kwargs.has_key? :issue_date

    invoice = Invoice.new(**kwargs)
    invoice.set_amounts
    invoice
  end

  #
  # Invoice Number
  #

  it "no need for an invoice number if it's a draft" do
    invoice = build_invoice(draft: true)
    invoice.save

    expect(invoice.number).to be nil
  end

  it "gets an invoice number after saving if it's not a draft" do
    invoice = build_invoice()
    invoice.save

    expect(invoice.number).to eq 1
  end

  it "may have the same number as another invoice from a different series" do
    invoice1 = build_invoice(series: Series.new(value: "A"))
    invoice1.save

    invoice2 = build_invoice(series: Series.new(value: "B"))
    invoice2.save

    expect(invoice1.number).to eq 1
    expect(invoice2.number).to eq invoice1.number
  end

  #
  # Status
  #

  it "returns the right status: draft" do
    invoice = build_invoice(draft: true)
    expect(invoice.get_status()).to eq :draft
  end

  it "returns the right status: failed" do
    invoice = build_invoice(failed: true)
    expect(invoice.get_status()).to eq :failed
  end

  it "returns the right status: pending (1/2)" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)])
    expect(invoice.get_status()).to eq :pending
    invoice.due_date = Date.current() + 1
    expect(invoice.get_status()).to eq :pending
  end

  it "returns the right status: pending (2/2)" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)], due_date: Date.current() + 1)
    expect(invoice.get_status()).to eq :pending
  end

  it "returns the right status: past due" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)], due_date: Date.current())
    expect(invoice.get_status()).to eq :past_due
  end

  it "returns the right status: paid" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)], payments: [Payment.new(amount: 10)])
    invoice.check_paid
    expect(invoice.get_status()).to eq :paid
  end

  #
  # Payments
  #

  it "computes payments right" do
    # No payment received
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)])
    # invoice.save

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 0
    expect(invoice.unpaid_amount).to eq 50

    # Partially paid
    invoice.payments << Payment.new(amount: 40)

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 40
    expect(invoice.unpaid_amount).to eq 10

    # Fully paid
    invoice.payments << Payment.new(amount: 10)

    invoice.check_paid
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.unpaid_amount).to eq 0
  end

  it "sets paid right" do
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)],
                            payments: [Payment.new(amount: 10, date: Date.current)])
    invoice.set_paid

    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.payments.length).to eq 2
    expect(invoice.payments[1].amount).to eq 40
  end

end
