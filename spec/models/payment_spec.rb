require 'rails_helper'

RSpec.describe Payment, :type => :model do

  it "is not valid without a date" do
    expect(Payment.new(amount: 10)).not_to be_valid
  end

  it "is not valid without an amount" do
    expect(Payment.new(date: Date.current)).not_to be_valid
  end

  it "is not valid with a non numeric amount" do
    expect(Payment.new(amount: 'hello!', date: Date.current)).not_to be_valid
  end

  it "is valid with an amount and a date" do
    expect(Payment.new(amount: 10, date: Date.current)).to be_valid
  end

end
