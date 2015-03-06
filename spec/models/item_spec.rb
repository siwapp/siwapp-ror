require 'rails_helper'

RSpec.describe Item, :type => :model do
  it "performs its own calculations properly" do
    item = FactoryGirl.build(:item)

    expect(item.taxes.length).to eq(0)

    expect(item.get_base_amount()).to eq(16.65)
    expect(item.get_discount_amount()).to eq(0)
    expect(item.get_net_amount()).to eq(16.65)
    expect(item.get_effective_tax_rate()).to eq(0)
    expect(item.get_tax_amount()).to eq(0)

    item = FactoryGirl.build(:item_complete, discount: 10)

    expect(item.taxes.length).to eq(1)

    expect(item.get_base_amount()).to eq(16.65)
    expect(item.get_discount_amount()).to eq(1.665)
    expect(item.get_net_amount()).to eq(14.985)
    expect(item.get_effective_tax_rate()).to eq(21)
    expect(item.get_tax_amount()).to eq(3.14685)

    item.taxes << FactoryGirl.build(:tax_retention)

    expect(item.taxes.length).to eq(2)

    expect(item.get_base_amount()).to eq(16.65)
    expect(item.get_discount_amount()).to eq(1.665)
    expect(item.get_net_amount()).to eq(14.985)
    expect(item.get_effective_tax_rate()).to eq(2)
    expect(item.get_tax_amount()).to eq(0.2997)

    item = FactoryGirl.build(:item)
    item.taxes << FactoryGirl.build(:tax_retention)

    expect(item.get_base_amount()).to eq(16.65)
    expect(item.get_discount_amount()).to eq(0)
    expect(item.get_net_amount()).to eq(16.65)
    expect(item.get_effective_tax_rate()).to eq(-19)
    expect(item.get_tax_amount()).to eq(-3.1635)
  end
end
