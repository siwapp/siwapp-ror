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

end
