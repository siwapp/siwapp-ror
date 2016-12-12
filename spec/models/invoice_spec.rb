require 'rails_helper'

RSpec.describe Invoice, :type => :model do

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

  it "is represented with series + number as string" do
    expect(FactoryGirl.build(:invoice).to_s).to eq("ES-")
    expect(FactoryGirl.create(:invoice).to_s).to eq("ES-1")
  end

end
