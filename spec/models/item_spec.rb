require 'rails_helper'

RSpec.describe Item, :type => :model do
  it "rounds the net_amount according to currency" do
    Settings.currency = "usd"
    item = Item.new(quantity: 1, discount: 5, unitary_cost: 0.08)
    expect(item.discount_amount).to eq 0.004
    expect(item.net_amount).to eq 0.08
    # BHD Bahrain Dinar has 3 decimals
    Settings.currency = "bhd"
    expect(item.net_amount).to eq 0.076
    # back to normal
    Settings.currency = "usd"
    expect(item.net_amount).to eq 0.08
  end
end
