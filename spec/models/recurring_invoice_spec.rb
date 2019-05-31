require 'rails_helper'

RSpec.describe RecurringInvoice, :type => :model do
  # WARNING: In these tests today is Wed, 01 Jun 2016!!!

  before do
    Timecop.freeze Date.new(2016, 6, 1)
    Celluloid.shutdown
    Celluloid.boot
  end

  after do
    Timecop.return
  end

  def build_recurring_invoice(**kwargs)
    kwargs[:starting_date] = Date.current() unless kwargs.has_key? :starting_date
    kwargs[:period_type] = 'month' unless kwargs.has_key? :period_type
    kwargs[:period] = 1 unless kwargs.has_key? :period
    kwargs[:series] = Series.new(value: "A") unless kwargs.has_key? :series

    customer = FactoryBot.create(:ncustomer)
    recurring_invoice = RecurringInvoice.new(
        name: customer.name, identification: customer.identification,
        customer:customer, **kwargs)
    recurring_invoice.set_amounts
    recurring_invoice
  end

  it "is active by default" do
    r = build_recurring_invoice()
    expect(r.enabled).to be true
  end

  it "is not valid, if active, without a start date" do
    r = build_recurring_invoice(starting_date: nil)
    expect(r).not_to be_valid
  end

  it "is not valid with a bad end date" do
    r = build_recurring_invoice(finishing_date: Date.new(2016, 5, 31))
    expect(r).not_to be_valid
    expect(r.errors.messages.has_key? :finishing_date).to be true
  end

  it "calculates next invoice date properly" do
    r = build_recurring_invoice()
    r.save

    expect(r.next_invoice_date).to eql r.starting_date

    RecurringInvoice.build_pending_invoices!
    r.reload

    expect(r.next_invoice_date).to eql Date.new(2016, 7, 1)
  end

  it "calculates next occurrences properly" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 4, 1), period_type: "day", period: 15)
    expect(r.next_occurrences).to eq [
      Date.new(2016, 4, 1),
      Date.new(2016, 4, 16),
      Date.new(2016, 5, 1),
      Date.new(2016, 5, 16),
      Date.new(2016, 5, 31)
    ]
  end

  it "builds pending invoices properly" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 4, 1))
    invoices = r.build_pending_invoices()
    expect(invoices.length).to eql 3
    expect(invoices[0].issue_date).to eq Date.new(2016, 4, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 5, 1)
    expect(invoices[2].issue_date).to eq Date.new(2016, 6, 1)
  end

  it "generates invoices according to max_occurrences" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 4, 1), max_occurrences: 2)
    invoices = r.build_pending_invoices()
    expect(invoices.length).to eql 2
    expect(invoices[0].issue_date).to eq Date.new(2016, 4, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 5, 1)
  end

  it "generates invoices according to finishing_date" do
    r = build_recurring_invoice(starting_date: Date.new(2016, 3, 1), finishing_date: Date.new(2016, 5, 1))
    invoices = r.build_pending_invoices()
    expect(invoices.length).to eql 3
    expect(invoices[0].issue_date).to eq Date.new(2016, 3, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 4, 1)
    expect(invoices[2].issue_date).to eq Date.new(2016, 5, 1)
  end

  it "class properly detects if there's any invoice to be generated" do
    expect(RecurringInvoice.any_invoices_to_be_built?).to be false
    build_recurring_invoice().save
    expect(RecurringInvoice.any_invoices_to_be_built?).to be true
  end

  it "class properly generates all pending invoices in order" do
    r1 = build_recurring_invoice(starting_date: Date.new(2016, 5, 1))
    r1.save
    r2 = build_recurring_invoice(starting_date: Date.new(2016, 5, 1))
    r2.save

    invoices = RecurringInvoice.build_pending_invoices!

    expect(invoices.length).to eql 4
    expect(invoices[0].issue_date).to eq Date.new(2016, 5, 1)
    expect(invoices[1].issue_date).to eq Date.new(2016, 5, 1)
    expect(invoices[2].issue_date).to eq Date.new(2016, 6, 1)
    expect(invoices[3].issue_date).to eq Date.new(2016, 6, 1)
  end

  it "is disabled when deleted and remains disabled when restored" do
    r = build_recurring_invoice()
    r.save
    expect(r.enabled).to be true

    expect(r.destroy).not_to be false
    expect(r.deleted?).to be true

    r.restore(recursive: true)
    expect(r.deleted?).to be false
    expect(r.enabled).to be false
  end
end
