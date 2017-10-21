require 'rails_helper'

RSpec.describe Tax, :type => :model do
  let(:klass) { described_class }

  describe "#validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:value) }
    # TODO: Implement when shoulda-matchers handles this in v4.0
    # https://github.com/thoughtbot/shoulda-matchers/issues/986
    # it { is_expected.to validate_numericality_of(:value) }
  end

  it "must have a name" do
    tax = Tax.new(value: '12')
    expect(tax).not_to be_valid
  end

  it "must have a value" do
    tax = Tax.new(name: 'tax_name')
    expect(tax).not_to be_valid
  end

  it "must have a numerical value" do
    expect { Tax.new(name: 'tax_name', value: 'tax') }.to raise_error(ArgumentError)
  end

  it "must be active and not default by default" do
    tax = Tax.create!(name: 'tax_name', value: '12')
    expect(tax).to be_valid
    expect(tax.active).to be true
    expect(tax.default).to be false
  end

  it "can't be deleted if an item has the tax" do
    tax = Tax.create!(name: 'tax_name', value: '12')
    Item.create!(taxes: [tax])
    expect(tax.destroy).to be false
  end
end
