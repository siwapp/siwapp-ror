require 'rails_helper'

RSpec.describe Series, :type => :model do

  it "is not valid without a value" do
    series = Series.new()
    expect(series).not_to be_valid
    expect(series.errors.messages.has_key? :value).to be true
  end

  it "gets 1 as first_number if none specified" do
    series = Series.new(value: "A")
    expect(series).to be_valid
    expect(series.first_number).to eq 1
  end

  it "can't be deleted if it has invoices that depend on it" do
    series = Series.new(value: "A")
    customer = FactoryBot.create(:ncustomer)
    series.commons << Invoice.new(name: customer.name, customer: customer,
                                  issue_date: Date.current)
    series.save
    expect(series.destroy).to be false
  end

  it "returns the first number as next_number if there's no invoice for this series" do
    series = Series.new(value: "A", first_number: 2)
    expect(series.next_number).to eq 2
  end

  it "properly returns the next number" do
    series = Series.new(value: "A", first_number: 2)
    customer = FactoryBot.create(:ncustomer)
    series.commons << Invoice.new(name: customer.name, customer: customer,
                                  issue_date: Date.current)
    series.save

    expect(series.next_number).to eq 3

    invoice = FactoryBot.create(:invoice, series: series)

    expect(invoice.number).to eq 3
    expect(series.next_number).to eq 4

    invoice.destroy

    expect(series.next_number).to eq 3
  end

  it "returns the default series properly" do
    Series.create(value: "A")
    Series.create(value: "B", default: true)

    expect(Series.default).not_to be nil
    expect(Series.default.value).to eq "B"
  end

  it "returns nil if no default series" do
    expect(Series.default).to be nil
  end

end
