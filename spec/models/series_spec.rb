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
    series.commons << Invoice.new(name: "A Customer", issue_date: Date.current)
    series.save
    expect(series.destroy).to be false
  end

  it "returns the first number as next_number if there's no invoice for this series" do
    series = Series.new(value: "A", first_number: 2)
    expect(series.next_number).to eq 2
  end

  it "properly returns the next number" do
    series = Series.new(value: "A", first_number: 2)
    series.commons << Invoice.new(name: "A Customer", issue_date: Date.current)
    series.save
    expect(series.next_number).to eq 3
  end

end
