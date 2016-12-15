require 'rails_helper'
require 'siwapp_tests_helper'

RSpec.describe RecurringInvoice, :type => :model do

  def build_recurring_invoice(**kwargs)
    kwargs[:starting_date] = Date.current() unless kwargs.has_key? :starting_date
    kwargs[:period_type] = 'month' unless kwargs.has_key? :period_type
    kwargs[:period] = 1 unless kwargs.has_key? :period
    build_common_as(RecurringInvoice, **kwargs)
  end

  before do
    Celluloid.shutdown; Celluloid.boot
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
    r = build_recurring_invoice(finishing_date: Date.current - 1)
    expect(r).not_to be_valid
    expect(r.errors.messages.has_key? :finishing_date).to be true
  end

  it "generates invoices according to max_occurrences" do
    r = build_recurring_invoice(starting_date: Date.current << 1, max_occurrences: 1)
    expect(r).to be_valid
    expect(r.get_pending_invoices.count).to eq 1
  end

  it "generates invoices according to finishing_date" do
    r = build_recurring_invoice(starting_date: Date.current << 5, finishing_date: Date.current)
    expect(r).to be_valid
    expect(r.get_pending_invoices.count).to eq 6
  end

end
