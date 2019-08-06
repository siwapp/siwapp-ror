require 'rails_helper'

RSpec.describe Item, :type => :model do

  it "rounds the net_amount according to currency" do
    c = FactoryBot.create(:common)
    item = Item.new(quantity: 1, discount: 5, unitary_cost: 0.08, common: c)
    expect(item.discount_amount).to eq 0.004
    expect(item.net_amount).to eq 0.08

    # BHD Bahrain Dinar has 3 decimals
    c.currency = "bhd"
    expect(item.net_amount).to eq 0.076
  end

  it "taxes_hash has net_amount * tax.value / 100.0" do
    c = FactoryBot.create(:common)
    tax1 = Tax.new(value: 10)
    tax2 = Tax.new(value: 25)
    item = Item.new(
      quantity:1,
      unitary_cost: 1,
      discount: 0.5,
      taxes: [tax1, tax2],
      common: c
    )
    expect(item.taxes_hash).to eq ({tax1 => 0.1, tax2 => 0.25})
  end

end
