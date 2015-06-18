require 'rails_helper'

RSpec.describe RecurringInvoice, :type => :model do
  it "is invalid without a series" do
    expect(FactoryGirl.build(:recurring_invoice, series: nil)).not_to be_valid
  end

  it "is invalid without a customer name" do
    expect(FactoryGirl.build(:recurring_invoice, customer_name: nil)).not_to be_valid
  end

  it "is invalid with bad e-mails" do
    expect(FactoryGirl.build(:recurring_invoice, customer_email: "paquito")).not_to be_valid
    expect(FactoryGirl.build(:recurring_invoice, customer_email: "paquito@example")).not_to be_valid
  end

  it "is invalid without a starting date" do
    expect(FactoryGirl.build(:recurring_invoice, starting_date: nil)).not_to be_valid
  end

  it "is represented with its customer name" do
    expect(FactoryGirl.build(:recurring_invoice).to_s).to eq("Example Customer Name")
  end

  it "performs totals calculations properly" do
    recurring_invoice = FactoryGirl.create(:recurring_invoice)

    expect(recurring_invoice.items.length).to eq(3)

    expect(recurring_invoice.base_amount).to eq(133.3)
    expect(recurring_invoice.discount_amount).to eq(10)
    expect(recurring_invoice.net_amount).to eq(123.3)
    expect(recurring_invoice.tax_amount).to eq(2.466)
    expect(recurring_invoice.gross_amount).to eq(125.766)
  end
end
