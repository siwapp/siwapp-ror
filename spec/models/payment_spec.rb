require 'rails_helper'

RSpec.describe Payment, :type => :model do
  let(:klass) { described_class }

  describe "#validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:amount) }
    # TODO: Implement when shoulda-matchers handles this in v4.0
    # https://github.com/thoughtbot/shoulda-matchers/issues/986
    # it { is_expected.to validate_numericality_of(:amount) }
  end

  it "is not valid without a date" do
    expect(Payment.new(amount: 10)).not_to be_valid
  end

  it "is not valid without an amount" do
    expect(Payment.new(date: Date.current)).not_to be_valid
  end

  it "is not valid with a non numeric amount" do
    expect { Payment.new(amount: 'hello!', date: Date.current) }.to raise_error(ArgumentError)
  end

  it "is valid with an amount and a date" do
    expect(Payment.new(amount: 10, date: Date.current)).to be_valid
  end

end
