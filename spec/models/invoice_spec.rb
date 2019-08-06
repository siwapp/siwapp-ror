require 'rails_helper'

RSpec.describe Invoice, :type => :model do

  def build_invoice(**kwargs)
    kwargs[:issue_date] = Date.current() unless kwargs.has_key? :issue_date
    kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series


    customer = FactoryBot.create(:ncustomer)
    invoice = Invoice.new(name: customer.name, identification: customer.identification,
                          customer: customer, **kwargs)
    invoice.set_amounts
    invoice
  end

  #
  # Invoice Number
  #

  it "has no invoice number if it's a draft" do
    invoice = build_invoice(draft: true, number: 1)
    invoice.save

    expect(invoice.number).to be nil
  end

  it "gets an invoice number after saving if it's not a draft" do
    series = Series.new(value: "A", first_number: 5)
    invoice1 = build_invoice(series: series)
    invoice1.save
    invoice2 = build_invoice(series: series)
    invoice2.save

    expect(invoice1.number).to eq 5
    expect(invoice2.number).to eq 6
  end

  it "may have the same number as another invoice from a different series" do
    invoice1 = build_invoice(series: Series.new(value: "A"))
    invoice1.save

    invoice2 = build_invoice(series: Series.new(value: "B"))
    invoice2.save

    expect(invoice1.number).to eq 1
    expect(invoice2.number).to eq invoice1.number
  end

  it "can't have the same number as another invoice from the same series" do
    invoice1 = build_invoice()
    expect(invoice1.save).to be true

    invoice2 = build_invoice(series: invoice1.series, number: invoice1.number)
    expect(invoice2.save).to be false
  end

  it "retains the same number after saving" do
    invoice = build_invoice(number: 2)
    invoice.save

    expect(invoice.number).to eq 2
  end

  it "loses the number on deletion" do
    invoice = build_invoice()
    invoice.save

    expect(invoice.number).to eq 1

    invoice.destroy
    invoice.reload

    expect(invoice.deleted?).to be true
    expect(invoice.number).to be_nil
  end

  it "can coexist, when deleted, with other deleted invoices in the same series" do
    invoice1 = build_invoice()
    expect(invoice1.save).to be true

    invoice2 = build_invoice(series: invoice1.series)
    expect(invoice2.save).to be true

    expect(invoice1.destroy).not_to be false
    expect(invoice2.destroy).not_to be false
  end

  it "when deleted stores number_was" do
    invoice = build_invoice()
    invoice.save
    number = invoice.number
    invoice.destroy
    invoice.reload
    expect(invoice.deleted_number).to eq number
  end

  it "is restored as draft" do
    invoice = build_invoice()
    invoice.save

    expect(invoice.destroy).not_to be false
    expect(invoice.deleted?).to be true

    invoice.restore(recursive: true)
    expect(invoice.deleted?).to be false
    expect(invoice.draft).to be true
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

  it "returns the right status: pending" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)], due_date: Date.current() + 1)
    expect(invoice.get_status()).to eq :pending
  end

  it "returns the right status: past due" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)],
                            due_date: Date.current())
    expect(invoice.get_status()).to eq :past_due
  end

  it "returns the right status: paid" do
    invoice = build_invoice(items: [Item.new(quantity: 1, unitary_cost: 10)],
                            payments: [Payment.new(amount: 10, date: Date.current)])
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
    invoice.payments << Payment.new(amount: 40, date: Date.current)

    invoice.check_paid
    expect(invoice.paid).to be false
    expect(invoice.paid_amount).to eq 40
    expect(invoice.unpaid_amount).to eq 10

    # Fully paid
    invoice.payments << Payment.new(amount: 10, date: Date.current)

    invoice.check_paid
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.unpaid_amount).to eq 0
  end

  it "sets paid right" do
    # A draft invoice can't be paid
    invoice = build_invoice(items: [Item.new(quantity: 5, unitary_cost: 10)], draft: true)

    expect(invoice.set_paid).to be false
    expect(invoice.paid).to be false

    # Remove draft switch and add a Payment; should be paid now
    invoice.payments << Payment.new(amount: 10, date: Date.current)
    invoice.check_paid
    invoice.draft = false

    expect(invoice.set_paid).to be true
    expect(invoice.paid).to be true
    expect(invoice.paid_amount).to eq 50
    expect(invoice.payments.length).to eq 2
    expect(invoice.payments[1].amount).to eq 40

    # A paid invoice should not be affected
    expect(invoice.set_paid).to be false
    expect(invoice.paid).to be true
  end

end
