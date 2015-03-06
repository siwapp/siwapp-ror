require 'rails_helper'

RSpec.describe Invoice, :type => :model do
  it "is invalid without a series" do
    expect(FactoryGirl.build(:invoice, serie: nil)).not_to be_valid
  end

  it "is invalid without a valid invoice number" do
    expect(FactoryGirl.build(:invoice, number: nil)).not_to be_valid
    expect(FactoryGirl.build(:invoice, number: "AAA")).not_to be_valid
  end

  it "is invalid with bad e-mails" do
    expect(FactoryGirl.build(:invoice, customer_email: "paquito")).not_to be_valid
    expect(FactoryGirl.build(:invoice, customer_email: "paquito@example")).not_to be_valid
  end

  it "is represented with series + number as string" do
    expect(FactoryGirl.build(:invoice).to_s).to eq("ES-1")
  end

  it "performs totals calculations properly" do
    invoice = FactoryGirl.create(:invoice_complete)

    expect(invoice.items.length).to eq(3)
    expect(invoice.payments.length).to eq(2)

    expect(invoice.base_amount).to eq(133.3)
    expect(invoice.discount_amount).to eq(10)
    expect(invoice.net_amount).to eq(123.3)
    expect(invoice.tax_amount).to eq(25.893)
    expect(invoice.gross_amount).to eq(149.193)
    expect(invoice.paid_amount).to eq(149.193)

    invoice.items << FactoryGirl.create(:item_complete, quantity: 1, unitary_cost: 100, with_retention: true)

    expect(invoice.items.length).to eq(4)
    invoice.set_amounts

    expect(invoice.base_amount).to eq(233.3)
    expect(invoice.discount_amount).to eq(10)
    expect(invoice.net_amount).to eq(223.3)
    expect(invoice.tax_amount).to eq(27.893) # VAT21% - IRPF19% == VAT2%
    expect(invoice.gross_amount).to eq(251.193)
    expect(invoice.paid_amount).to eq(149.193)
  end
end
