require 'rails_helper'

RSpec.describe Invoice, :type => :model do
  it "is invalid without a series" do
    expect(FactoryGirl.build(:invoice, series: nil)).not_to be_valid
  end

  it "has no invoice number if it is a draft" do
    invoice = FactoryGirl.create(:invoice, draft: true)
    expect(invoice.number).to be_nil
  end

  it "has an invoice number if it is not a draft" do
    invoice1 = FactoryGirl.create(:invoice)
    expect(invoice1.number).to eq(1)

    invoice2 = FactoryGirl.create(:invoice, series: invoice1.series)
    expect(invoice2.number).to eq(2)

    expect(invoice2.series.first_number).to eq(1)
  end

  it "is invalid with bad e-mails" do
    expect(FactoryGirl.build(:invoice, email: "paquito")).not_to be_valid
    expect(FactoryGirl.build(:invoice, email: "paquito@example")).not_to be_valid
  end

  it "is represented with series + number as string" do
    expect(FactoryGirl.build(:invoice).to_s).to eq("ES-")
    expect(FactoryGirl.create(:invoice).to_s).to eq("ES-1")
  end

  it "performs totals calculations properly" do
    invoice = FactoryGirl.create(:invoice)
    expect(invoice.items.length).to eq(3)
    expect(invoice.payments.length).to eq(2)

    expect(invoice.net_amount).to eq(123.3)
    expect(invoice.gross_amount).to eq(125.76)
    expect(invoice.paid_amount).to eq(125.77)
  end
end
