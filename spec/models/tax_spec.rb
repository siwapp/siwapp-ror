require 'rails_helper'

RSpec.describe Tax, :type => :model do
  it "must have a name" do
    tax = Tax.new(value: '12')
    expect(tax).not_to be_valid
  end

  it "must have a value" do
    tax = Tax.new(name: 'tax_name')
    expect(tax).not_to be_valid
  end

  it "must have a numerical value" do
    tax = Tax.new(name: 'tax_name', value: 'tax')
    expect(tax).not_to be_valid
  end

  it "must be active and not default by default" do
    tax = Tax.create!(name: 'tax_name', value: '12')
    expect(tax).to be_valid
    expect(tax.active).to be true
    expect(tax.default).to be false
  end

  it "can't be deleted if an item has the tax" do
    tax = Tax.create!(name: 'tax_name', value: '12')
    item = Item.create!(taxes: [tax])
    expect(tax.destroy).to be false
  end
end
