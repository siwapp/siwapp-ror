require 'rails_helper'

RSpec.describe Payment, :type => :model do

  describe "#validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount) }
  end

  it "valid payment" do
    expect(Payment.new(amount: 10, date: Date.current, invoice: Invoice.new)).to be_valid
  end

end
