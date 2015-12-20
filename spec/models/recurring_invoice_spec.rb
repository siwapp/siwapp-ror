require 'rails_helper'

RSpec.describe RecurringInvoice, :type => :model do
  it "is invalid without a series" do
    expect(FactoryGirl.build(:recurring_invoice, series: nil)).not_to be_valid
  end

  it "is invalid without a customer name" do
    expect(FactoryGirl.build(:recurring_invoice, name: nil)).not_to be_valid
  end

  it "is invalid with bad e-mails" do
    expect(FactoryGirl.build(:recurring_invoice, email: "paquito")).not_to be_valid
    expect(FactoryGirl.build(:recurring_invoice, email: "paquito@example")).not_to be_valid
  end

  it "active is invalid without a starting date" do
    expect(FactoryGirl.build(:recurring_invoice, status: 1, starting_date: nil)).not_to be_valid
  end

  it "active is invalid without max_occurrences and finishing date" do
    expect(FactoryGirl.build(:recurring_invoice, status: 1, finishing_date: nil,
                             max_occurrences: nil)
           ).not_to be_valid
  end

  for field in [:max_occurrences, :finishing_date]
    it "active is valid with either max_occurrences or finishing date" do
      expect(FactoryGirl.build(:recurring_invoice, status: 1, field =>  nil)
             ).to be_valid
    end
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

  it "generates invoices according to max_occurrences" do
    expect(FactoryGirl.build(:recurring_invoice, status: 1, starting_date: Date.today << 1).generate_pending_invoices.count).to eq(5)
  end

  it "generates invoices according to finishing_date" do
    expect(FactoryGirl.build(:recurring_invoice, status: 1, starting_date: Date.today << 1, max_occurrences: nil).generate_pending_invoices.count).to eq(31)
  end
end
